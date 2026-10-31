{
  config,
  lib,
  settings,
  ...
}:
let
  cfg = settings.systemSettings.mango;
in
{
  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;
    programs.waybar = {
      enable = true;
      systemd.target = "graphical-session.target";
    };
    environment.loginShellInit = ''
      [ "$(tty)" = /dev/tty1 ] && exec mango
    '';
  };
}
