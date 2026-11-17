{
  lib,
  settings,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      cores = 10;
      max-jobs = 1;
    };
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
  };
  time.timeZone = "America/Vancouver";

  networking.hostName = "${settings.hostname}";

  system.stateVersion = "26.11";
}
