{ ... }:
let
  mqttHost = "mqtt.home.arpa";
in
{
  services.mprisMqttBridge = {
    # Flip to true after mpris-mqtt-adapter is installed and reachable in PATH.
    enable = false;
    executable = "mpris-mqtt-adapter";
    extraArgs = [
      "--host" mqttHost
      "--port" "1883"
      "--topic" "workstation/media"
      "--discovery"
    ];
  };
}
