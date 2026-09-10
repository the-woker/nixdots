{ pkgs, ... }:
{
  boot = {
    plymouth = {
      enable = true;
      themePackages = [ inputs.evangelion-ui.packages.${pkgs.system}.evangelion-ui ];
      theme = "evangelion-ui";
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
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
        extraConfig = ''
          /Windows 11
              protocol: efi
              path: uuid(3e00b069-3e86-4856-bd70-89f3244c14d4):/EFI/Microsoft/Boot/bootmgfw.efi
              comment: Boot Windows 11
        '';
      };
      grub.enable = false;
    };
  };
}
