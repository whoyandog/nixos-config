{ lib, config, ... }:
let
  cfg = config.services.mprisMqttBridge;
in
{
  options.services.mprisMqttBridge = {
    enable = lib.mkEnableOption "MPRIS to MQTT bridge user service";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "Package providing the bridge executable.";
    };

    executable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Absolute path or executable name to run when package is not used.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments passed to the bridge executable.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional systemd EnvironmentFile with MQTT credentials and settings.";
    };

    wantedBy = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default.target" ];
      description = "Systemd user targets that should start this service.";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      bridgeCmd =
        if cfg.package != null then
          lib.getExe cfg.package
        else
          cfg.executable;
    in
    {
      assertions = [
        {
          assertion = bridgeCmd != null;
          message = "services.mprisMqttBridge: set package or executable when enable = true.";
        }
      ];

      home.packages = lib.optional (cfg.package != null) cfg.package;

      systemd.user.services.mpris-mqtt-bridge = {
        Unit = {
          Description = "MPRIS to MQTT bridge";
          After = [ "graphical-session.target" "network-online.target" ];
          Wants = [ "network-online.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service =
          {
            Type = "simple";
            ExecStart = lib.escapeShellArgs ([ bridgeCmd ] ++ cfg.extraArgs);
            Restart = "on-failure";
            RestartSec = 3;
          }
          // lib.optionalAttrs (cfg.environmentFile != null) {
            EnvironmentFile = toString cfg.environmentFile;
          };

        Install = {
          WantedBy = cfg.wantedBy;
        };
      };
    }
  );
}
