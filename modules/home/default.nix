{
  inputs,
  settings,
  pkgs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit inputs pkgs settings; };

  home-manager.users.${settings.name} = {
    imports = [
      inputs.nvf.homeManagerModules.default
      ./home.nix
      ./neovim.nix
    ];
  };
}
