{pkgs, ...}: {
  # Generic (non-NVIDIA) desktop portal setup for niri/Wayland.
  # desktop.nix overrides RemoteDesktop to use the gnome portal instead,
  # to work around a NVIDIA + Zen browser specific issue.
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config.niri = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      "org.freedesktop.impl.portal.RemoteDesktop" = ["wlr"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      "org.freedesktop.impl.portal.Settings" = ["gtk"];
    };
  };
}
