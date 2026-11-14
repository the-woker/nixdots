{
  config,
  pkgs,
  lib,
  settings,
  ...
}: let
  cfg = settings.systemSettings.users;
in {
  config = lib.mkIf cfg.enable {
    users = {
      defaultUserShell = pkgs.zsh;
      mutableUsers = true;
      users.${settings.name} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "bluetooth"
          "audio"
          "input"
        ];
        packages = with pkgs; [tree];
      };
    };
    services.getty.autologinUser = settings.name;
  };
}
