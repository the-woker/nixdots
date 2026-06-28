{ inputs, name, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.${name} = {
    imports = [
      inputs.nvf.homeManagerModules.default
      ./home.nix
      ./neovim.nix
    ];
  };
}
