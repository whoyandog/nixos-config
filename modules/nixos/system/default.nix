{ pkgs, ... } : {
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

    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;

        # Use GNOME portal for screencast picker compatibility with browser clients.
        extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];

        config = {
            common.default = [ "gnome" "gtk" "wlr" ];
            niri."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            niri."org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            niri."org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
    };
}