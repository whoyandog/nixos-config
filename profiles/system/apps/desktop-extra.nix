{pkgs, inputs, ...}: {

  environment.systemPackages = with pkgs; [
    qutebrowser
    krita
    discord
    libreoffice

    inputs.yandex-music.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.flatpak.enable = true;
}