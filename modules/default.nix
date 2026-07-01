{
  inputs,
  lib,
  pkgs,
  settings,
  ...
}:
{

  _module.args = {
    inherit inputs lib settings;
    disks = [ "/dev/nvme0n1" ];
  };
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.mangowm.nixosModules.mango
    ./system
    ./home
  ];

}
