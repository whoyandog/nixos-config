{ pkgs, ... } : {

    services.sing-box = {
        enable = true;
    };

    systemd.services.sing-box.serviceConfig.ExecStart = [
        ""
        "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -c /home/dmitry/.config/secrets/sing-box.json run"
    ];

    programs.proxychains = {
        enable = true;
        proxies = {
            myproxy = {
               enable = true;
               type = "socks5";
               host = "127.0.0.1";
               port = 1080;
            };
        };
    };
}
