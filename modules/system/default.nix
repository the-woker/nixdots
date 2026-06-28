{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  # Recursively collects all files in a directory and subdirectories
  getDir =
    dir:
    mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else file) (
      builtins.readDir dir
    );

  # Collects only `.nix` files and filters out unwanted ones (like default.nix)
  importAll =
    dir:
    builtins.filter (
      file:
      hasSuffix ".nix" file
      && file != "default.nix"
      && !lib.hasPrefix "x/taffybar/" file
      && !lib.hasSuffix "-hm.nix" file
    ) (builtins.attrNames (getDir dir));

  # Constructs full paths for valid `.nix` files
  files = map (file: ./${file}) (importAll ./.);
in
{
  _module.args.disks = [ "/dev/nvme0n1" ];
  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];
  imports = files;

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      e2fsprogs
      zlib
      freetype
      fontconfig
      libGL
      glib
      libX11
    ];
  };
}
