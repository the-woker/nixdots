{
  inputs,
  lib,
  config,
  settings,
  ...
}:
let
  cfg = settings.systemSettings.flatpak;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  config = lib.mkIf cfg.enable {

    services.flatpak.remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    services.flatpak.update.auto.enable = false;
    services.flatpak.uninstallUnmanaged = false;

    services.flatpak.packages = [
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
}
