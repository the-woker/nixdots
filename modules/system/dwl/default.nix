{
  config,
  lib,
  inputs,
  pkgs,
  settings,
  ...
}: let
  moldStdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.stdenv;

  customDwl =
    (pkgs.dwl.override {
      stdenv = moldStdenv;
      configH = ./${settings.hostname}.h;
    }).overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          ./ipc.patch
        ];
    });

  dwlStartup = pkgs.writeShellScript "dwl-startup" ''
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP=wlroots
    systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gtk.service
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.awww}/bin/awww-daemon &
    ${pkgs.bluez}/bin/mpris-proxy &
  '';
in {
  environment.systemPackages = [
    customDwl
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["gtk"];
    config.wlroots.default = ["wlr" "gtk"];
  };

  programs.waybar.enable = true;

  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec dwl -s ${dwlStartup}
  '';
}
