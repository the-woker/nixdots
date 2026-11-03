{ pkgs, inputs, ... }:
{
  boot = {

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = false;
      limine = {
        maxGenerations = 5;
        enable = true;
        efiSupport = true;
        resolution = "1920x1080x32";
      };
      grub.enable = false;
    };
  };

}
