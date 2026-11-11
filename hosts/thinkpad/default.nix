{
  inputs,
  pkgs,
  ...
}:
let
  settings = import ./settings.nix;
in
{

  _module.args = {
    inherit settings;
    disks = [ "/dev/nvme0n1" ];
  };

  imports = [
    ../../modules
  ];

}
