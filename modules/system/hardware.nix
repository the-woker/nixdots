{
  lib,
  config,
  settings,
  ...
}:
let
  cfg = settings.systemSettings.nvidia;
in
{
  config = lib.mkMerge [
    {
      hardware.enableAllFirmware = true;
      hardware.graphics.enable = true;

      nixpkgs.config.allowUnfree = true;
      programs.xwayland.enable = true;

      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 16 * 1024;
          randomEncryption.enable = true;
        }
      ];
    }
    (lib.mkIf cfg.enable {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
    })
  ];
}
