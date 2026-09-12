{ pkgs, inputs, ... }:
{
  boot = {
    plymouth = {
      enable = true;
      theme = "evangelion-ui";
      extraConfig = ''
        [Daemon]
        ShowDelay=0
      '';
      themePackages = [
        (inputs.evangelion-ui.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
          installPhase = ''
            mkdir -p $out/share/plymouth/themes/evangelion-ui
            cp evangelion-ui.plymouth evangelion-ui.script $out/share/plymouth/themes/evangelion-ui/
            tar -xzf images.tar.gz -C $out/share/plymouth/themes/evangelion-ui/

            substituteInPlace $out/share/plymouth/themes/evangelion-ui/evangelion-ui.plymouth \
              --replace "EVANGELION_UI_PATH" "$out"
          '';
        }))
      ];
    };
    initrd.systemd.enable = true;

    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    initrd.availableKernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "plymouth.use-simpledrm"
      "plymouth.ignore-serial-consoles"
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
  systemd.services.plymouth-quit = {
    description = "Hold Plymouth splash screen for fast boot";
    serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 2"; # Change 2 to however many seconds you want to see the animation
  };

  systemd.services."getty@tty1" = {
    after = [ "plymouth-quit.service" ];
    wants = [ "plymouth-quit.service" ];
  };
}
