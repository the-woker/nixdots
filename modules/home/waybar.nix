{...}: let
in {
  programs.waybar = {
    enable = true;
    style = ''

      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", monospace;
        font-size: 13px;
        font-weight: bold;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 0);
        color: #ffffff;
        min-height: 24px;
      }

      #tags {
        background-color: #0a0a0a;
        border: 1px solid #242424;
        border-radius: 6px;
        padding: 0px 6px;
        margin: 2px 0px 2px 8px;
      }

      #tags button {
        color: #850505;
        background-color: transparent;
        border: none;
        border-radius: 4px;
        min-width: 0;
        padding: 0px 8px;
        margin: 1px 2px;
      }

      #tags button.occupied:not(.focused) {
        color: #b00707;
      }

      #tags button.focused {
        color: #d40000;
      }

      #tags button:hover {
        box-shadow: none;
        text-shadow: none;
        background: transparent;
      }

      #mpris {
        background-color: #0a0a0a;
        color: #d40000;
        border: 1px solid #242424;
        border-radius: 6px;
        padding: 0px 10px;
        margin-top: 2px;
        margin-bottom: 2px;
        margin-left: 8px;
      }

      #mpris.paused {
        color: #850505;
      }

      #clock,
      #wireplumber,
      #battery,
      #cpu,
      #memory,
      #custom-reload,
      #custom-power {
        background-color: #0a0a0a;
        color: #d40000;
        border: 1px solid #242424;
        border-radius: 6px;
        padding: 0px 10px;
        margin-top: 2px;
        margin-bottom: 2px;
        margin-right: 8px;
      }

      #custom-reload {
        color: #d40000;
      }

      #custom-power {
        padding: 0px 8px;
        color: #d40000;
        font-size: 13px;
      }
    '';
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
          format = "{volume}% 󰕾";
          format-muted = "󰖁";
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
