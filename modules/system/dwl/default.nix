{
  config,
  lib,
  inputs,
  pkgs,
  settings,
  ...
}: let
  dwlPatch = pkgs.writeShellScriptBin "dwl-patch" ''
    set -euo pipefail

    HOST=$(${pkgs.nettools}/bin/hostname)
    case "$HOST" in
      desktop|thinkpad) ;;
      *)
        echo "Error: Unsupported hostname '$HOST'. Expected 'desktop' or 'thinkpad'."
        exit 1
        ;;
    esac

    DWL_DIR="$HOME/nixdots/modules/system/dwl"
    WORK_DIR="/tmp/dwl-work"
    CONFIG_H="$DWL_DIR/$HOST.h"
    COMBINED_PATCH="$DWL_DIR/patches/combined.patch"

    case "''${1:-}" in
      init)
        rm -rf "$WORK_DIR" && mkdir -p "$WORK_DIR"
        SRC_PATH=$(nix build --no-link --print-out-paths "$HOME/nixdots#nixosConfigurations.$HOST.pkgs.dwl.src")
        cp -r "$SRC_PATH" "$WORK_DIR/source"
        chmod -R u+w "$WORK_DIR/source"
        cd "$WORK_DIR/source"

        ${pkgs.git}/bin/git init -q
        ${pkgs.git}/bin/git add .
        ${pkgs.git}/bin/git commit -q -m "base"

        if [ -f "$COMBINED_PATCH" ] && [ -s "$COMBINED_PATCH" ]; then
          ${pkgs.git}/bin/git apply "$COMBINED_PATCH"
          ${pkgs.git}/bin/git add -A
          ${pkgs.git}/bin/git commit -q -m "existing patches"
        fi

        if [ -n "''${2:-}" ]; then
          PATCH_FILE=$(realpath "$2")
          echo "Applying $PATCH_FILE..."
          ${pkgs.git}/bin/git apply --reject "$PATCH_FILE" || true
        fi

        echo "Workbench ready at: $WORK_DIR/source (using $HOST.h)"
        ;;

      build)
        cd "$WORK_DIR/source"
        cp "$CONFIG_H" config.h
        eval "$(nix print-dev-env "$HOME/nixdots#nixosConfigurations.$HOST.pkgs.dwl")"
        buildPhase
        echo "Build succeeded against $HOST.h! Run 'dwl-patch save' to export combined.patch."
        ;;

      save)
        cd "$WORK_DIR/source"
        rm -f dwl *.o *-protocol.h *-protocol.c config.h *.rej
        ${pkgs.git}/bin/git add -A
        BASE_COMMIT=$(${pkgs.git}/bin/git rev-list --max-parents=0 HEAD)
        ${pkgs.git}/bin/git diff "$BASE_COMMIT" > "$COMBINED_PATCH"
        ${pkgs.git}/bin/git -C "$HOME/nixdots" add "$COMBINED_PATCH" "$DWL_DIR/desktop.h" "$DWL_DIR/thinkpad.h"
        echo "Saved $COMBINED_PATCH and staged desktop.h and thinkpad.h"
        ;;

      *)
        echo "Usage: dwl-patch <init [new.patch] | build | save>"
        exit 1
        ;;
    esac
  '';

  dwlStartup = pkgs.writeShellScript "dwl-startup" ''
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP=wlroots
    systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gtk.service
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.awww}/bin/awww-daemon &
    ${pkgs.bluez}/bin/mpris-proxy &
  '';
in {
  nixpkgs.overlays = [
    (final: prev: {
      dwl =
        (prev.dwl.override {
          stdenv = prev.stdenvAdapters.useMoldLinker prev.stdenv;
          configH = ./${settings.hostname}.h;
        }).overrideAttrs (oldAttrs: {
          buildInputs =
            (oldAttrs.buildInputs or [])
            ++ [
              final.unstable.scenefx
              final.libGL
            ];
          patches =
            (oldAttrs.patches or [])
            ++ [
              ./patches/combined.patch
            ];
        });
    })
  ];

  environment.systemPackages = [
    pkgs.dwl
    dwlPatch
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["gtk"];
    config.wlroots.default = ["wlr" "gtk"];
  };

  programs.waybar.enable = true;

  # [ "$(tty)" = /dev/tty1 ] && exec dwl -s ${dwlStartup}
  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec dwl
  '';
}
