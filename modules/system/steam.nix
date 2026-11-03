{
  pkgs,
  lib,
  config,
  settings,
  ...
}:
let
  cfg = settings.systemSettings.steam;
in
{
  config = lib.mkIf cfg.enable {
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
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
