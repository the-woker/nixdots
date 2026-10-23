{
  config,
  settings,
  pkgs,
  inputs,
  ...
}:
let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.enableNixpkgsReleaseCheck = false;
  imports = [
    ./theme.nix
    ./zsh.nix
    ./zen.nix
  ];
  home.username = settings.name;
  home.homeDirectory = "/home/${settings.name}";
  home.stateVersion = "26.05";
  xdg.configFile =
    let
      apps = [
        "nvim"
        "waybar"
        "ghostty"
        "fastfetch"
        "mango"
        "tmux"
        "wofi"
        "starship.toml"
      ];
    in
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = {
          source = "${inputs.configs}/${name}";
        };
      }) apps
    );

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

  xdg.desktopEntries = {
    wl-color-picker = {
      exec = "wl-color-picker";
      genericName = "Color Picker";
      name = "Color Picker";
      terminal = false;
    };
  };
  programs.git.enable = true;
  programs.git.settings.user.name = "woker";
  programs.git.settings.user.email = "settings.email";

  services.mpris-proxy.enable = true;

}
