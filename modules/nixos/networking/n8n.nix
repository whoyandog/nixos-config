{ lib, pkgs, config, ... }:
let
  cfg = config.local.networking.n8n;

  defaultEditorBaseUrl = "${cfg.protocol}://${cfg.host}:${toString cfg.port}";
in {
  options.local.networking.n8n = {
    enable = lib.mkEnableOption "n8n automation service";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host/address n8n listens on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5678;
      description = "TCP port for n8n.";
    };

    protocol = lib.mkOption {
      type = lib.types.enum [ "http" "https" ];
      default = "http";
      description = "Protocol used by n8n for generated URLs.";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Moscow";
      description = "Timezone for n8n schedules and date operations.";
    };

    editorBaseUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Public base URL of n8n editor, e.g. https://n8n.example.com.";
    };

    webhookUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Public base URL used to build webhook callback URLs.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open n8n port in firewall.";
    };

    envFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Optional path to environment file with secrets.
        Example values: N8N_ENCRYPTION_KEY, N8N_BASIC_AUTH_USER,
        N8N_BASIC_AUTH_PASSWORD, TELEGRAM_BOT_TOKEN, HH_API_TOKEN.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.n8n = {
      description = "n8n workflow automation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = lib.filterAttrs (_: value: value != null) {
        HOME = "/var/lib/n8n";
        N8N_USER_FOLDER = "/var/lib/n8n";

        N8N_HOST = cfg.host;
        N8N_PORT = toString cfg.port;
        N8N_PROTOCOL = cfg.protocol;
        N8N_SECURE_COOKIE = if cfg.protocol == "https" then "true" else "false";

        N8N_EDITOR_BASE_URL = if cfg.editorBaseUrl != null then cfg.editorBaseUrl else defaultEditorBaseUrl;
        WEBHOOK_URL = cfg.webhookUrl;

        DB_TYPE = "sqlite";
        DB_SQLITE_DATABASE = "/var/lib/n8n/database.sqlite";

        EXECUTIONS_DATA_PRUNE = "true";
        EXECUTIONS_DATA_MAX_AGE = "336";
        TZ = cfg.timezone;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.n8n}/bin/n8n start";
        Restart = "always";
        RestartSec = "5s";

        DynamicUser = true;
        StateDirectory = "n8n";
        WorkingDirectory = "/var/lib/n8n";
      } // lib.optionalAttrs (cfg.envFile != null) {
        EnvironmentFile = cfg.envFile;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}