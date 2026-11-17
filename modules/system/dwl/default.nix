{
  config,
  lib,
  settings,
  inputs,
  pkgs,
  ...
}: let
  cfg = settings.systemSettings.mango;

  moldStdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv;

  customDwl =
    (pkgs.dwl.override {
      stdenv = moldStdenv;
      configH = ./config.h;
    }).overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          ./ipc.patch
        ];
    });

  dwlStartup = pkgs.writeShellScript "dwl-startup" ''
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.awww}/bin/awww-daemon &
    ${pkgs.bluez}/bin/mpris-proxy &
  '';
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      customDwl
    ];

    programs.waybar.enable = true;

    environment.loginShellInit = ''
      [ "$(tty)" = /dev/tty1 ] && exec dwl -s ${dwlStartup}
    '';
  };
}
