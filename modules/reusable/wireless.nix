{
  config,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      experimental = true; # show battery

      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
  };

  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Allows resolving .local domains using IPv4
    openFirewall = true; # Automatically opens UDP 5353 for mDNS
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };
  };
}
