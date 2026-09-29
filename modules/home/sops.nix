{config, ...}: {
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      caldav = {};
      tu-ics = {};
      runna-ics = {};
      atuin = {};
    };

    templates."tu-ics".content = ''
      "${config.sops.placeholder.tu-ics}"
    '';
  };
}
