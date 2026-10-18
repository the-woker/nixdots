{
  description = "Standalone dotfiles managed by Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "ratjerky";
      dotfilesPath = "/home/${username}/dotfiles";
    in
    {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          ({ config, pkgs, ... }: {
            home.username = username;
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "26.05";

            programs.home-manager.enable = true;

            home.file = {
              ".choice-of-shell-starship-target".path = ".config/starship.toml";
              ".config/starship.toml".source =
                config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/starship.toml";
              ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/tmux/tmux.conf";

              ".config/alacritty".source =
                config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/alacritty";
              ".config/fastfetch".source =
                config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/fastfetch";
              ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/ghostty";
              ".config/mango".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/mango";
              ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/nvim";
              ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/waybar";
              ".config/wofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/configs/wofi";
            };
          })
        ];
      };
    };
}
