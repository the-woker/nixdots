{
  config,
  pkgs,
  lib,
  settings,
  ...
}:
let
  cfg = settings.systemSettings.users;
in
{
  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;
    users.mutableUsers = false;
    services.getty.autologinUser = settings.name;
    users.users.${settings.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "bluetooth"
        "audio"
        "input"
      ];
      packages = with pkgs; [ tree ];
    };
  };
}
