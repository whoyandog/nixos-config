{ pkgs, ... }:
let
  mqttHost = "mqtt.home.arpa";
in
{
  services.mprisMqttBridge = {
    enable = true;
    package = pkgs.mpris-mqtt-adapter;
    extraArgs = [
      "--host" mqttHost
      "--port" "1883"
      "--topic" "workstation/media"
      "--discovery"
    ];
  };
}
