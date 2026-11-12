{
  pkgs,
  lib,
  config,
  settings,
  ...
}: let
  cfg = settings.homeSettings.zsh;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-themes-extra
      tokyonight-gtk-theme
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      iconTheme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
    };

    home.sessionVariables = {
      XCURSOR_THEME = config.home.pointerCursor.name;
      XCURSOR_SIZE = toString config.home.pointerCursor.size;
      GDK_BACKEND = "wayland,x11";
    };
  };
}
