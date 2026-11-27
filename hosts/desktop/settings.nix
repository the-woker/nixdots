{
  name = "ratjerky";
  email = "wokerNM@proton.me";
  hostname = "desktop";
  confBranch = "main";
  configH = ./desktop.h;
  homeSettings = {
    zen.enable = true;
    zsh.enable = true;
    theme.enable = true;
  };
  systemSettings = {
    tlp.enable = false;
    windows.enable = true;
    disko.enable = true;
    flatpak.enable = true;
    font.enable = true;
    mango.enable = true;
    nvidia.enable = true;
    network.enable = true;
    obs.enable = true;
    sops.enable = true;
    steam.enable = true;
    users.enable = true;
    wireless.enable = true;
  };
}
