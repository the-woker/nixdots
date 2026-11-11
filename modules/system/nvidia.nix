{
  inputs,
  settings,
  pkgs,
  lib,
  config,
  ...
}:
let
  nvidiaStuff = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  cfg = settings.systemSettings.nvidia;
in
{
  config = lib.mkIf cfg.enable {
    boot = {
      initrd.kernelModules = nvidiaStuff;
      initrd.availableKernelModules = nvidiaStuff;
      kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
      ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
