{
  inputs,
  lib,
  pkgs,
  settings,
  ...
}:
{

  _module.args = {
    inherit
      inputs
      lib
      settings
      ;
    disks = [ "/dev/nvme0n1" ];
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./reusable
    ./system
    ./home
  ]
  ++ lib.optional settings.systemSettings.disko.enable inputs.disko.nixosModules.disko
  ++ lib.optional settings.systemSettings.mango.enable inputs.mangowm.nixosModules.mango
  ++ lib.optional settings.systemSettings.flatpak.enable inputs.nix-flatpak.nixosModules.nix-flatpak
  ++ lib.optional settings.systemSettings.sops.enable inputs.sops-nix.nixosModules.sops;

}
