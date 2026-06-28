{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extest.enable = true; # Wayland support

    # Optional Steam features
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;

    package = pkgs.steam.override {
      extraEnv = {
        # MANGOHUD = "1";
        # OBS_VKCAPTURE = "1";
        # RADV_TEX_ANISO = "16";
      };
    };

    extraPackages = with pkgs; [
      gamescope
      # mangohud
      gamemode
    ];

    extraCompatPackages = with pkgs; [
      steamtinkerlaunch
      proton-ge-bin
    ];
  };

  environment.sessionVariables = {
    # Default 64-bit Wine prefix for modern games
    # WINEPREFIX = "$HOME/.wine";
    # WINEARCH = "win64";

    # Vulkan / gaming tweaks
    # MANGOHUD = "1";
    # OBS_VKCAPTURE = "1";
    # RADV_TEX_ANISO = "16";

    # Explicit Wine paths for Winetricks / Protontricks (avoids unknown arch)
    # WINE = "/run/current-system/sw/bin/wine";
    # WINESERVER = "/run/current-system/sw/bin/wineserver";

    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
