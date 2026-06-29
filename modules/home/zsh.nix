{ name, ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      pkg = "nvim ~/nixdots/modules/system/packages.nix && nrs";
      npa = "nix profile add .";
      die = "shutdown -h now";
      nrs = "sudo nixos-rebuild switch --flake ~/nixdots#nixos";
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
      vm = "sudo nixos-rebuild build-vm --flake /home/${name}/nixdots#live-vm";
    };

    sessionVariables = {
      LS_COLORS = "di=0;35:fi=0;37:ln=0;36:so=0;32:pi=0;33:ex=0;31:";
      SDL_VIDEODRIVER = "x11";
      CC = "gcc";
      CXX = "g++";
      CMAKE_GENERATOR = "Ninja";
      EDITOR = "nvim";
      BAT_THEME = "base16";
    };

    initContent = ''
      bindkey -s '^T' 'tmux\n'

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

  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
