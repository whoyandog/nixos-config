{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "pulseaudio" "battery" "tray" ];

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        network = {
          format-wifi = "Wi-Fi {signalStrength}%";
          format-ethernet = "LAN";
          format-disconnected = "Offline";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "Muted";
          format-icons = {
            default = [ "Vol" "Vol" "Vol" ];
          };
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}%";
          format-charging = "+ {capacity}%";
          format-full = "Full";
          format-icons = [ "Bat" "Bat" "Bat" "Bat" "Bat" ];
        };
      };
    };
  };
}
