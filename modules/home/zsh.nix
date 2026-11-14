{
  lib,
  config,
  settings,
  ...
}: let
  cfg = settings.homeSettings.zsh;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        upscale = "upscayl-bin -m /run/current-system/sw/share/upscayl-ncnn/models -n digital-art-4x -i";
        ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}'";
        pkg = "nvim ~/nixdots/modules/system/packages.nix && nrs";
        npa = "nix profile add .";
        die = "shutdown -h now";
        nrs = "sudo nixos-rebuild switch --flake ~/nixdots#${settings.hostname}";
        hms = "home-manager switch --flake ~/nixdots#${settings.name}@${settings.hostname}";
        hmup = "nix flake update configs --flake ~/nixdots && home-manager switch -b backup --flake ~/nixdots#${settings.name}@${settings.hostname}";
        tat = "tmux attach -t";
        tns = "tmux new-session";
        lg = "lazygit";
        f = "clear; fastfetch";
        nv = "nvim";
        ls = "ls --color=auto";
        grep = "grep --color=auto";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        xterm = "xterm -bg black -fg white";
        kbdbrightnessdwn = "sudo brightnessctl -d smc::kbd_backlight set 5%-";
        kbdbrightnessup = "sudo brightnessctl -d smc::kbd_backlight set +5%";
        td = "tmux detach";
        ta = "tmux attach";
        py = "python";
        headp = "bluetoothctl connect 9C:DE:F0:52:E1:0B";
      };

      sessionVariables = {
        LS_COLORS = "di=0;35:fi=0;37:ln=0;36:so=0;32:pi=0;33:ex=0;31:";
        SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
        SDL_VIDEODRIVER = "x11";
        CC = "gcc";
        CXX = "g++";
        CMAKE_GENERATOR = "Ninja";
        EDITOR = "nvim";
        BAT_THEME = "base16";
        TZDIR = "/etc/zoneinfo";
      };

      initContent = ''
        bindkey -s '^T' 'tmux\n'


        function udots() {
          cd ~/configs || return 1
          git add .
          local files
          files=$(git diff --cached --name-only | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')
          local msg="Update configs''${files:+: $files}"
          git commit -m "$msg"
          git push
          nix flake update configs --flake ~/nixdots
          home-manager switch --flake ~/nixdots
        }

        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r  cwd < "$tmp"
              [ "''${cwd}" != "''${PWD}" ] && [ "''${cwd}" ] && builtin cd -- "''${cwd}"
            rm -f -- "$tmp"
        }



        bindkey -s '^E' 'y\n'

        eval "$(starship init zsh)"
        eval "$(zoxide init zsh)"
        eval "$(direnv hook zsh)"

        echo -ne '\e[6 q'
      '';
    };

    programs = {
      starship.enable = true;
      zoxide.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
