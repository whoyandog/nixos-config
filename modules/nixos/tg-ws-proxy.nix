{ config, lib, pkgs, ... }:

let
  cfg = config.services.tg-ws-proxy;
in
{
  options.services.tg-ws-proxy = {
    enable = lib.mkEnableOption "tg-ws-proxy MTProto WebSocket bridge for Telegram";

    port = lib.mkOption {
      type = lib.types.port;
      default = 1443;
      description = "Port to listen on.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address to listen on.";
    };

    dcIPs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "2:149.154.167.220" "4:149.154.167.220" ];
      example = [ "1:149.154.175.53" "2:149.154.167.220" "3:149.154.175.100" "4:149.154.167.220" "5:91.108.56.130" ];
      description = ''
        List of DC:IP mappings for Telegram data centers.
        Format: "DC_NUMBER:IP_ADDRESS"
      '';
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable debug logging.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tg-ws-proxy = {
      description = "tg-ws-proxy MTProto WebSocket Bridge";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";

        # DynamicUser создаёт временного системного пользователя автоматически
        DynamicUser = true;
        StateDirectory = "tg-ws-proxy";

        # Генерируем секрет один раз при первом запуске и сохраняем его,
        # чтобы при рестарте сервиса не нужно было переподключать Telegram.
        ExecStartPre = pkgs.writeShellScript "tg-ws-proxy-init-secret" ''
          SECRET_FILE="$STATE_DIRECTORY/secret"
          if [ ! -f "$SECRET_FILE" ]; then
            ${pkgs.openssl}/bin/openssl rand -hex 16 > "$SECRET_FILE"
            chmod 600 "$SECRET_FILE"
          fi
        '';

        ExecStart = pkgs.writeShellScript "tg-ws-proxy-start" ''
          SECRET=$(cat "$STATE_DIRECTORY/secret")
          exec ${lib.getExe pkgs.tg-ws-proxy} \
            --host ${cfg.host} \
            --port ${toString cfg.port} \
            --secret "$SECRET" \
            ${lib.concatMapStringsSep " " (dc: "--dc-ip ${dc}") cfg.dcIPs} \
            ${lib.optionalString cfg.verbose "--verbose"}
        '';

        Restart = "on-failure";
        RestartSec = "5s";

        # Харденинг
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        SystemCallFilter = [ "@system-service" ];
      };

      # После запуска выводим ссылку для подключения в журнал
      postStart = ''
        echo "Connect Telegram: tg://proxy?server=${cfg.host}&port=${toString cfg.port}&secret=dd$(cat /var/lib/tg-ws-proxy/secret)"
      '';
    };
  };
}
