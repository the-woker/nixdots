{ pkgs, ... }:
{

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
  # networking.firewall.enable = false;

  networking.firewall.allowedTCPPorts = [
    22
    53317
  ];
}
