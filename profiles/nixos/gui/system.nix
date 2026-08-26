{pkgs, ...}: {
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
}
