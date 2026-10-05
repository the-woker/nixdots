{ pkgs, ... }:
{

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
  # networking.firewall.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      7000
      7001
      7100
      22
      5353
      53317
    ];
    allowedUDPPorts = [
      5353
      6000
      6001
      7011
    ];
  };

}
