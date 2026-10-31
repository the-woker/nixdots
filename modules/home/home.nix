{
  config,
  settings,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = settings.systemSettings.sops;
in
{
  imports = [
    ./theme.nix
    ./zsh.nix
    ./zen.nix
  ];
  config = lib.mkMerge [
    {
      home.enableNixpkgsReleaseCheck = false;
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
      programs.git.settings.user.email = settings.email;

      services.mpris-proxy.enable = true;
    }
    (lib.mkIf cfg.enable {
      programs.ssh.settings = {
        "*" = {
          IdentityFile = "/run/secrets/nick-ssh-private";
        };
      };
    })
  ];

}
