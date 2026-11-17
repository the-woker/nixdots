{
  config,
  lib,
  settings,
  inputs,
  pkgs,
  ...
}: let
  cfg = settings.systemSettings.mango;

  dwlStartup = pkgs.writeShellScript "dwl-startup" ''
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.awww}/bin/awww-daemon &
    ${pkgs.bluez}/bin/mpris-proxy &
  '';
in {
  config = lib.mkIf cfg.enable {
    programs.mango = {
      enable = true;
      package = pkgs.withMold pkgs.unstable.mango;
    };

    programs.waybar.enable = true;

    environment.loginShellInit = ''
      [ "$(tty)" = /dev/tty1 ] && exec dwl -s ${dwlStartup}
    '';
  };
}
