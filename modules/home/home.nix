{
  config,
  settings,
  lib,
  pkgs,
  inputs,
  ...
}: let
  targetSystem = pkg: pkg.packages.x86_64-linux.default;
  cfg = settings.systemSettings.sops;
  branch = settings.confBranch or "main";
  configsSrc = inputs."configs-${branch}";
in {
  imports = [
    ./theme.nix
    ./zsh.nix
    ./zen.nix
  ];
  config = lib.mkMerge [
    {
      home.packages = with pkgs;
        [
          clang-tools

          gcc
          cmake
          ninja
          gdb
        ]
        ++ map targetSystem (
          with inputs; [
            nvim
            fetch
          ]
        );
      home.enableNixpkgsReleaseCheck = false;
      home.username = settings.name;
      home.homeDirectory = "/home/${settings.name}";
      home.stateVersion = "26.05";
      xdg.configFile = let
        apps = [
          "waybar"
          "ghostty"
          "fastfetch"
          "mango"
          "tmux"
          "wofi"
          "wallp"
          "starship.toml"
        ];
      in
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = {
              source = "${configsSrc}/${name}";
            };
          })
          apps
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
        vm-curator = {
          name = "VM Curator";
          genericName = "QEMU/KVM Virtual Machine Manager";
          comment = "Manage desktop KVM virtual machines in a TUI";
          exec = "ghostty -e vm-curator";
          icon = "utilities-terminal";
          categories = [
            "System"
            "Emulator"
          ];
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
