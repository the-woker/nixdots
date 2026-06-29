{
  config,
  pkgs,
  name,
  ...
}:
{
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;
  services.getty.autologinUser = name;
  users.users.${name} = {
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
