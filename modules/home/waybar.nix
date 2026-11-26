{
  config,
  settings,
  inputs,
  ...
}: let
  branch = settings.confBranch or "main";
  configsSrc = inputs."configs-${branch}";
in {
  programs.waybar = {
    enable = true;
    style = "${configsSrc}/waybar/style.css";
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;

        modules-left = [
          "mpris"
        ];
        modules-center = [
          "dwl/tags"
        ];
        modules-right = [
          "clock"
          "wireplumber"
          "battery"
          "cpu"
          "memory"
          "custom/reload"
          "custom/power"
        ];

        "dwl/tags" = {
          num-tags = 9;
          tag-labels = ["" "" "" "" "" "" "" "" ""];
        };

        battery = {
          interval = 30;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ϟ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        mpris = {
          format = "{player_icon} {title} - {artist} - {album}";
          dynamic-order = ["title" "artist" "album" "position"];
          format-paused = "{status_icon} <i>{title} - {artist} - {album}</i>";
          max-length = 40;
          player-icons = {
            default = "▶ ";
            spotify = " ";
            firefox = " ";
          };
          status-icons = {
            paused = "⏸ ";
          };
        };

        clock = {
          timezone = "America/Vancouver";
          format = "⏲ {:%H:%M}";
        };

        wireplumber = {
          format = "{volume}%   ";
          format-muted = "  ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        cpu = {
          format = " {usage}%";
        };

        memory = {
          interval = 5;
          format = " {used:.2f}GiB";
          tooltip-format = "Total: {total:.2f}GiB\nAvailable: {avail:.2f}GiB\nSwap Used: {swapUsed:.2f}GiB";
        };

        "custom/reload" = {
          format = "↻";
          on-click = "reboot";
        };

        "custom/power" = {
          format = "⏻";
          on-click = "poweroff";
        };
      };
    };
  };
}
