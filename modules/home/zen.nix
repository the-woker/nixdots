{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  catppuccin-zen = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zen-browser";
    rev = "main";
    hash = "sha256-5A57Lyctq497SSph7B+ucuEyF1gGVTsuI3zuBItGfg4=";
  };

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    # Check these out at about:config
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    # ...
  };

  extensions = [
    (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
    (extension "adnauseam" "adnauseam@rednoise.org")
    (extension "trackmenot-fork" "trackmenot-fork@paradonym")
  ];
in
{
  home.packages = [
    (pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "Startpage";
                URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}";
                IconURL = "https://www.startpage.com/favicon.ico";
                Alias = "@sp";
              }
            ];
          };
        };
      }
    )
  ];

  home.file = {
    ".zen/profiles.ini".text = ''
      [Profile0]
      Name=default
      IsRelative=1
      Path=default
      Default=1

      [General]
      StartWithLastProfile=1
      Version=6
    '';

    ".zen/default/chrome/userChrome.css".text = ''
      @import "${catppuccin-zen}/themes/Mocha/Lavender/userChrome.css";
    '';

    ".zen/default/chrome/userContent.css".text = ''
      @import "${catppuccin-zen}/themes/Mocha/Lavender/userContent.css";
    '';

    ".zen/default/user.js".text = ''
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      user_pref("ui.systemUsesDarkTheme", 1);
      user_pref("browser.theme.content-theme", 0);
      user_pref("browser.theme.toolbar-theme", 0);
      user_pref("extensions.autoDisableScopes", 0);
      user_pref("extensions.pocket.enabled", false);
    '';
  };
}
