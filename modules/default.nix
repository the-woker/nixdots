{
  inputs,
  lib,
  pkgs,
  ...
}:
{

  _module.args = {
    name = "ratjerky";
    inherit inputs lib;
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

  # Optional shared args for all modules

  nixpkgs.overlays = [
  ];
}
