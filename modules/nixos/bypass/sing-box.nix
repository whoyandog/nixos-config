{ pkgs, ... } : {
    services.sing-box = {
        enable = true;
    };

    systemd.services.sing-box.serviceConfig.ExecStart = [
        ""
        "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -c /home/dmitry/.config/secrets/sing-box.json run"
    ];
}
