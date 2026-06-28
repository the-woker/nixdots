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
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    # ...
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
