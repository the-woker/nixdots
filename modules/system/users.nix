{
  config,
  pkgs,
  settings,
  ...
}:
{
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
    ];
    packages = with pkgs; [ tree ];
    hashedPasswordFile = config.sops.secrets.passwd.path;
  };
}
