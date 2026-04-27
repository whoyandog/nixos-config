{ lib, pkgs, config, ... }:
let
    cfg = config.local.networking.singBox;
in {
    options.local.networking.singBox.configPath = lib.mkOption {
        type = lib.types.str;
        default = "/etc/sing-box/config.json";
        description = "Path to sing-box JSON config file.";
    };

    config = {
        services.sing-box = {
            enable = true;
        };

        systemd.services.sing-box.serviceConfig.ExecStart = [
            ""
            "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -c ${cfg.configPath} run"
        ];
    };
}
