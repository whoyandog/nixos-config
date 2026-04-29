{ lib, config, ... }:
let
  cfg = config.services.mprisMqttAdapter;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "services" "mprisMqttBridge" ] [ "services" "mprisMqttAdapter" ])
  ];

  options.services.mprisMqttAdapter = {
    enable = lib.mkEnableOption "MPRIS to MQTT adapter user service";

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
      adapterCmd =
        if cfg.package != null then
          lib.getExe cfg.package
        else
          cfg.executable;
    in
    {
      assertions = [
        {
          assertion = adapterCmd != null;
          message = "services.mprisMqttAdapter: set package or executable when enable = true.";
        }
      ];

      home.packages = lib.optional (cfg.package != null) cfg.package;

      systemd.user.services.mpris-mqtt-adapter = {
        Unit = {
          Description = "MPRIS to MQTT adapter";
          After = [ "graphical-session.target" "network-online.target" ];
          Wants = [ "network-online.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service =
          {
            Type = "simple";
            ExecStart = lib.escapeShellArgs ([ adapterCmd ] ++ cfg.extraArgs);
            Restart = "on-failure";
            RestartSec = 3;
          }
          // lib.optionalAttrs (cfg.environmentFile != null) {
            EnvironmentFile = toString cfg.environmentFile;
          };

        Install = {
          WantedBy = cfg.wantedBy;
          Alias = [ "mpris-mqtt-bridge.service" ];
        };
      };
    }
  );
}
