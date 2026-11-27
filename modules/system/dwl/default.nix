{
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
    CONFIG_H="$HOME/nixdots/hosts/$HOST/$HOST.h"
    COMBINED_PATCH="$DWL_DIR/patches/combined.patch"

    case "''${1:-}" in
      init)
        rm -rf "$WORK_DIR" && mkdir -p "$WORK_DIR"
        mkdir -p "$DWL_DIR/patches"

        # Pull raw upstream source from nixpkgs input directly so broken local patches don't block init
        SRC_PATH=$(nix build --no-link --print-out-paths "$HOME/nixdots#nixosConfigurations.$HOST.pkgs.dwl.src")
        cp -r "$SRC_PATH" "$WORK_DIR/source"
        chmod -R u+w "$WORK_DIR/source"
        cd "$WORK_DIR/source"

        ${pkgs.git}/bin/git init -q
        ${pkgs.git}/bin/git config user.email "dwl-patch@local"
        ${pkgs.git}/bin/git config user.name "dwl-patch"
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
        if [ ! -f "$CONFIG_H" ]; then
          echo "Error: $CONFIG_H not found."
          exit 1
        fi
        cp -f "$CONFIG_H" config.h

        nix develop "$HOME/nixdots#nixosConfigurations.$HOST.pkgs.dwl" \
          --command bash -c 'export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgs.wayland-scanner.dev}/lib/pkgconfig"; make clean dwl'
        echo "Build succeeded against $HOST.h! Run 'dwl-patch save' to export combined.patch."
        ;;

      save)
        cd "$WORK_DIR/source"
        rm -f dwl *.o *-protocol.h *-protocol.c config.h *.rej *.orig
        ${pkgs.git}/bin/git add -A
        BASE_COMMIT=$(${pkgs.git}/bin/git rev-list --max-parents=0 HEAD)
        ${pkgs.git}/bin/git diff "$BASE_COMMIT" > "$COMBINED_PATCH"

        for f in "$COMBINED_PATCH" "$DWL_DIR/desktop.h" "$DWL_DIR/thinkpad.h"; do
          [ -f "$f" ] && ${pkgs.git}/bin/git -C "$HOME/nixdots" add "$f"
        done
        echo "Saved $COMBINED_PATCH and staged available host headers."
        ;;

      *)
        echo "Usage: dwl-patch <init [new.patch] | build | save>"
        exit 1
        ;;
    esac
  '';
in {
  nixpkgs.overlays = [
    (final: prev: {
      dwl =
        (prev.dwl.override {
          stdenv = prev.stdenvAdapters.useMoldLinker prev.stdenv;
          configH = settings.configH;
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

  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec dwl
  '';
}
