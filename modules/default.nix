{
  inputs,
  lib,
  pkgs,
  settings,
  ...
}:
{

  _module.args = {
    inherit
      inputs
      lib
      settings
      ;
    disks = [ "/dev/nvme0n1" ];
  };

  imports = [
    ./system
    ./home
  ]

}
