{ config, lib, pkgs, ... }:

let
  cfg = config.local.networking.zapret;
  qnum = toString cfg.qnum;
  execStart = "${pkgs.zapret}/bin/nfqws --pidfile=/run/nfqws.pid --qnum=${qnum} "
    + lib.concatStringsSep " " cfg.args;
in
{
  options.local.networking.zapret = {
    enable = lib.mkEnableOption "zapret DPI bypass for Discord and YouTube";

    qnum = lib.mkOption {
      type = lib.types.int;
      default = 200;
      description = "Номер очереди NFQUEUE. Меняй только если 200 уже занят.";
    };

    whitelist = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "discord.com"
        "discordapp.com"
        "discordapp.net"
        "discord.gg"
        "discord.media"
        "gateway.discord.gg"
        "cdn.discordapp.com"
        "media.discordapp.net"
        "images-ext-1.discordapp.net"
        "images-ext-2.discordapp.net"
        "youtube.com"
        "www.youtube.com"
        "m.youtube.com"
        "youtu.be"
        "googlevideo.com"
        "ytimg.com"
        "yt3.ggpht.com"
        "yt4.ggpht.com"
        "youtube-nocookie.com"
        "youtubei.googleapis.com"
        "youtube.googleapis.com"
      ];
      description = "Список доменов, для которых применяется обход. Остальной трафик не затрагивается.";
    };

    whitelistFile = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      default = pkgs.writeText "zapret-whitelist"
        (lib.concatStringsSep "\n" cfg.whitelist);
      description = "Путь к файлу whitelist в Nix store (read-only, вычисляется автоматически из whitelist).";
    };

    args = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        Полный список аргументов nfqws (без --pidfile и --qnum).
        Несколько стратегий разделяются через "--new".
        Ссылки на пути:
          whitelist: config.local.networking.zapret.whitelistFile
          fake-бинарники: pkgs.zapret + "/usr/share/zapret/files/fake/"
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = cfg.args != [];
      message = "local.networking.zapret: укажи args. Запусти blockcheck для определения параметров провайдера.";
    }];

    systemd.services.zapret = {
      description = "DPI bypass service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = execStart;
        Type = "simple";
        PIDFile = "/run/nfqws.pid";
        Restart = "always";
        RuntimeMaxSec = "1h";
        DevicePolicy = "closed";
        KeyringMode = "private";
        PrivateTmp = true;
        PrivateMounts = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
      };
    };

    networking.nftables.tables.zapret = {
      family = "inet";
      content = ''
        chain postrouting {
          type filter hook postrouting priority mangle; policy accept;

          # HTTPS/HTTP
          tcp dport { 80, 443, 2053, 2083, 2087, 2096, 8443 } \
            ct original packets 1-6 meta mark & 0x40000000 != 0x40000000 \
            queue flags bypass to ${qnum}

          # QUIC + Discord UDP
          udp dport { 443, 19294-19344, 50000-50100 } \
            ct original packets 1-3 meta mark & 0x40000000 != 0x40000000 \
            queue flags bypass to ${qnum}
        }
      '';
    };
  };
}
