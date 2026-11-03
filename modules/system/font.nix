{
  pkgs,
  lib,
  config,
  settings,
  ...
}:
let
  cfg = settings.systemSettings.font;
in
{
  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      fontconfig.enable = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
      ];
    };
  };
}
