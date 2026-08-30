{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/system/nvidia
    ../../modules/system/logitech
    ../../modules/system/steam
    ../../modules/system/tg-ws-proxy.nix
    ./gui
    ./apps-common.nix
    ./network-bypass.nix
  ];

  # NVIDIA + Zen browser specific portal override: RemoteDesktop must go
  # through the gnome portal instead of wlr on this machine.
  xdg.portal.config.niri."org.freedesktop.impl.portal.RemoteDesktop" = lib.mkForce ["gnome"];

  services.printing = {
    enable = true;
    drivers = [pkgs.epson-escpr];
  };
  hardware.sane.enable = true;
  users.users.dmitry.extraGroups = ["scanner" "lp"];

  environment.systemPackages = with pkgs; [
    simple-scan

    # wallpapers
    awww

    qutebrowser

    # yandex music
    inputs.yandex-music.packages.${pkgs.stdenv.hostPlatform.system}.default

    # graphic redactor
    krita

    # discord
    discord

    # libreoffice
    libreoffice
  ];

  services.flatpak.enable = true;
}
