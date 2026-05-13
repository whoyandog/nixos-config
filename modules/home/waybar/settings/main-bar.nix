{
  layer = "top";
  position = "top";
  exclusive = true;
  fixed-center = true;
  margin-top = 16;
  margin-left = 16;
  margin-right = 16;

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
    format = "{icon} {volume}%";
    format-muted = "󰝟 Muted";
    format-icons = {
      default = [ "󰕿" "󰖀" "󰕾" ];
    };
  };
}
