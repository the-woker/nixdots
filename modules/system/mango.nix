{
  config,
  lib,
  settings,
  inputs,
  pkgs,
  ...
}: let
  cfg = settings.systemSettings.mango;
in {
  config = lib.mkIf cfg.enable {
    programs.mango = {
      enable = true;
      package = pkgs.withMold pkgs.unstable.mango;
    };
    programs.waybar = {
      enable = true;
      systemd.target = "graphical-session.target";
    };
    environment.loginShellInit = ''
      [ "$(tty)" = /dev/tty1 ] && exec mango
    '';
  };
}
