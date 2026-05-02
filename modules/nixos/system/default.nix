{ pkgs, ... } : {
    services.upower.enable = true;

    # Required for desktop portal authorization prompts in Wayland sessions.
    security.polkit.enable = true;

    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;

        # `wlr` provides screencast on wlroots-like compositors; `gtk` handles file chooser.
        extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];

        config = {
            common.default = [ "wlr" "gtk" ];
            niri."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            niri."org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            niri."org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };
    };
}