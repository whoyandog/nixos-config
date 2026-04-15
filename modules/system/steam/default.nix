{ pkgs, ... } : {

    services.xserver.enable = true;

    programs.steam = {
        enable = true;
    };

    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
        xwayland-satellite 
        vulkan-loader
        vulkan-tools
    ];
}