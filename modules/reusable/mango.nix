{
  programs.mango.enable = true;
  programs.waybar = {
    enable = true;
    systemd.target = "graphical-session.target";
  };
  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec mango
  '';
}
