{ pkgs, lib, ... } : {
    services.upower.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-pipewire-audio-capture
        ];
    };

    # Required for desktop portal authorization prompts in Wayland sessions.
    security.polkit.enable = true;

    # Portals configuration for NVIDIA because Zen bad works with gnome portals and NVIDIA
    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;

        extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
        ];

        config.niri = {
            default = lib.mkForce [ "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
            "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
    };
}