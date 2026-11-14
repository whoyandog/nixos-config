{pkgs, ...}: {
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;

    package = pkgs.steam.override {
      extraLibraries = pkgs:
        with pkgs; [
          libxtst
          libvdpau
        ];
    };

    extraPackages = with pkgs; [
      libxtst
      libvdpau
      pulseaudio
      psmisc
    ];
  };

  programs.xwayland.enable = true;
}
