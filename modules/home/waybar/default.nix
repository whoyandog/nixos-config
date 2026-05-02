{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.readFile ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "niri/language" "pulseaudio" "tray" ];

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        "niri/language" = {
          format = "{}";
          format-en = "EN";
          format-ru = "RU";
        };

        network = {
          format-wifi = "Wi-Fi {signalStrength}%";
          format-ethernet = "WAN";
          format-disconnected = "Off";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "Muted";
          format-icons = {
            default = [ "Vol" "Vol" "Vol" ];
          };
        };

      };
    };
  };
}
