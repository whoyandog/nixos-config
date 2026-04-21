{ pkgs, ... } : {

    services.xserver.enable = true;
    services.xserver.excludePackages = [ pkgs.xterm ];

    programs.steam = {
        enable = true;
    };

    programs.xwayland.enable = true;
}