{
  config,
  name,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/nixdots/modules/home/configs";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    rofi = "rofi";
    alacritty = "alacritty";
    picom = "picom";
    waybar = "waybar";
    quickshell = "quickshell";
    ghostty = "ghostty";
    fastfetch = "fastfetch";
    mango = "mango";
    tmux = "tmux";
  };
in
{
  home.enableNixpkgsReleaseCheck = false;
  imports = [
    ../user/theme.nix
    ./zsh.nix
    ./zen.nix
  ];
  home.username = name;
  home.homeDirectory = "/home/${name}";
  home.stateVersion = "26.05";

  programs.mangohud.enable = true;

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.file.".config/starship.toml".source = ./configs/starship.toml;

  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityFile = "/run/secrets/nick-ssh-private";
      };
    };
  };

  programs.git.enable = true;
  programs.git.settings.user.name = "woker";
  programs.git.settings.user.email = "wokerNM@proton.me";

}
