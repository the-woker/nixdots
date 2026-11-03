{
  inputs,
  settings,
  pkgs,
  dots,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.extraSpecialArgs = {
    inherit
      inputs
      pkgs
      settings
      ;
  };
  home-manager.users.${settings.name} = {
    imports = [
      ./home.nix
    ];
  };
}
