{
  lib,
  config,
  settings,
  inputs,
  ...
}: let
  cfg = settings.systemSettings.flatpak;
in {
  imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      update.auto.enable = false;
      uninstallUnmanaged = false;
      packages = [
        {
          appId = "com.github.Matoking.protontricks";
          origin = "flathub";
        }
        {
          appId = "com.usebottles.bottles";
          origin = "flathub";
        }
      ];
    };
  };
}
