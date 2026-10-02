{pkgs, ...}: let
  vpn-up = pkgs.writeShellApplication {
    name = "vpn-up";
    runtimeInputs = [pkgs.keepassxc pkgs.zenity pkgs.coreutils];
    text = ''
      db="$HOME/.local/share/vpn.kdbx"
      auth="$XDG_RUNTIME_DIR/vpn-auth"

      master=$(zenity --password --title="Unlock VPN vault")

      user=$(printf '%s' "$master" | keepassxc-cli show -q -a UserName "$db" company-vpn)
      pass=$(printf '%s' "$master" | keepassxc-cli show -q -s -a Password "$db" company-vpn)
      totp=$(printf '%s' "$master" | keepassxc-cli show -q -t "$db" company-vpn)

      echo "$user"
      echo "$pass"
      echo "$totp"

      b64() { printf '%s' "$1" | base64 -w0; }

      umask 077
      printf '%s\nSCRV1:%s:%s\n' "$user" "$(b64 "$pass")" "$(b64 "$totp")" > "$auth"

      sudo systemctl restart openvpn-company.service
      sleep 10
      rm -f "$auth"
    '';
  };
in {
  services.openvpn.servers.company = {
    autoStart = false;
    config = ''
      config /home/jzep/Documents/vpn/vpn.ovpn
      auth-user-pass /run/user/1000/vpn-auth
    '';
  };

  # let your user start the VPN without a sudo password prompt
  security.sudo.extraRules = [
    {
      users = ["jzep"];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl restart openvpn-company.service";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = [vpn-up pkgs.keepassxc];

  # run it on login
  systemd.user.services.vpn-up = {
    description = "Unlock vault and connect company VPN";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${vpn-up}/bin/vpn-up";
    };
  };
}
