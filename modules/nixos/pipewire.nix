{pkgs, ...}: {
  services.pulseaudio.enable = false;
  hardware.alsa.enablePersistence = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."context.properties" = {
      default.clock.rate = 44100; # or 44100 if your hardware prefers it
      default.clock.allowed-rates = [
        44100
        48000
      ];
      default.clock.quantum = 2048; # try 512 or 1024 (higher = more latency, fewer dropouts)
      default.clock.min-quantum = 1024;
      default.clock.max-quantum = 4096;
    };
  };

  environment.systemPackages = with pkgs; [
    playerctl
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true; # if you're okay with unfree firmware
  hardware.firmware = [pkgs.linux-firmware];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Privacy = "device";
        # Enable = "Source,Sink,Media,Socket";
        # ControllerMode = "dual";
        JustWorksRepairing = "always";
        FastConnectable = true;
        Experimental = true;
        Class = "0x000100";
      };

      # Policy = {
      #   AutoEnable = true;
      # };
    };
  };
}
