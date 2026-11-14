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
      home = {
        packages = with pkgs;
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
        enableNixpkgsReleaseCheck = false;
        username = settings.name;
        homeDirectory = "/home/${settings.name}";
        stateVersion = "26.05";
      };
      xdg.configFile = let
        apps = [
          "waybar"
          "ghostty"
          "fastfetch"
          "mango"
          "matuwall"
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

      programs = {
        home-manager.enable = true;
        ssh = {
          enable = true;
          enableDefaultConfig = false;
        };
        git = {
          enable = true;
          settings.user = {
            name = "woker";
            email = settings.email;
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
