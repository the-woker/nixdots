{lib, ...}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      cores = 0;
      max-jobs = 2;
    };
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
  };
  time.timeZone = "America/Vancouver";

  networking.hostName = lib.mkDefault "nixos";

  system.stateVersion = "26.11";
}
