{lib, ...}: {
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    cores = 0;
    max-jobs = "auto";
  };
  nix.optimise.automatic = true;

  time.timeZone = "America/Vancouver";

  networking.hostName = lib.mkDefault "nixos";

  system.stateVersion = "26.11";
}
