{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extest.enable = true;

    package = pkgs.steam.override {
      extraEnv = {
      };
    };

    extraPackages = with pkgs; [
      gamescope
      gamemode
    ];

    extraCompatPackages = with pkgs; [
      steamtinkerlaunch
      proton-ge-bin
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Necessary for KMS screen capture on Linux
    openFirewall = true; # Automatically opens necessary UDP/TCP ports
  };
}
