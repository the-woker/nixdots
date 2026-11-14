{
  inputs,
  lib,
  pkgs,
  settings,
  ...
}:
with lib; let
  getDir = dir:
    mapAttrs (file: type:
      if type == "directory"
      then getDir "${dir}/${file}"
      else file) (
      builtins.readDir dir
    );

  importAll = dir:
    builtins.filter (file: hasSuffix ".nix" file && file != "default.nix") (
      builtins.attrNames (getDir dir)
    );

  files = map (file: ./${file}) (importAll ./.);
in {
  _module.args.disks = ["/dev/nvme0n1"];
  imports = files;

  programs.dconf.enable = true;
  services.earlyoom.enable = true;
  programs.ccache.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    stdenv.cc.cc.lib
  ];
}
