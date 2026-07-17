{ lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "America/Vancouver";

  networking.hostName = lib.mkDefault "nixos";

  system.stateVersion = "26.11";
}
