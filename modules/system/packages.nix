{
  pkgs,
  inputs,
  config,
  ...
}: let
  targetSystem = pkg: pkg.packages.x86_64-linux.default;
in {
  nixpkgs.overlays = [
    inputs.matuwall.overlays.default
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = config.nixpkgs.config.allowUnfree or true;
      };
    })
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
  environment.systemPackages = with pkgs;
    [
      vim
      wget
      curl
      git
      luarocks
      zsh
      playerctl
      pamixer
      zoxide
      starship
      blueman
      nodejs
      clang
      clang-tools
      libclang
      lua
      stylua
      unzip
      glslang
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers
      cmake
      ninja
      btop
      steam
      lazygit
      nixpkgs-fmt
      nil
      fzf
      direnv
      fastfetch
      alsa-utils
      gnat15
      nix-prefetch-github
      freefont_ttf
      glfw
      zip
      python3
      file
      icu
      age
      sops
      yazi
      discord
      vlc
      protonup-qt
      unrar
      quickshell
      jq
      limine-full
      ghostty
      wl-clipboard
      grim
      satty
      slurp
      ffmpeg
      swaybg
      wl-color-picker
      tmux
      usbutils
      psmisc
      yt-dlp
      spotify
      awww
      nvtopPackages.nvidia
      lm_sensors
      dmidecode
      wine
      nix-search-tv
      bluez-experimental
      nixfmt
      bluetui
      lutris
      uxplay
      avahi
      waybar
      gum
      helvum
      wofi
      github-cli
      upscayl-ncnn
      pciutils
      wl-clip-persist
      masterpdfeditor4
      brightnessctl
    ]
    ++ (with pkgs.unstable; [
      matuwall
    ])
    ++ map targetSystem (
      with inputs; [
        newp
        fibpass
        neko
      ]
    );
}
