{
  pkgs,
  inputs,
  lib,
  settings,
  ...
}: {
  boot = {
    consoleLogLevel = 3;
    kernelModules = [];
    initrd = {
      kernelModules = [];
      availableKernelModules = [];
    };

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
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        default = 0;
        splashImage = null;
        theme = "${inputs.grub}/berserk";
        configurationLimit = 5;
        extraEntries = lib.mkIf settings.systemSettings.windows.enable ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root <YOUR-SDA1-UUID>
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      systemd-boot.enable = false;
      # limine = {
      #   maxGenerations = 5;
      #   enable = true;
      #   efiSupport = true;
      #   resolution = "1920x1080x32";
      #   extraEntries = lib.mkIf settings.systemSettings.windows.enable ''
      #     /Windows 11
      #         protocol: efi
      #         path: uuid(3e00b069-3e86-4856-bd70-89f3244c14d4):/EFI/Microsoft/Boot/bootmgfw.efi
      #         comment: Boot Windows 11
      #   '';
      # };
    };
  };
}
