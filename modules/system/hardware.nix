{
  lib,
  config,
  settings,
  ...
}:
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
