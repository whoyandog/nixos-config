{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../../modules/system/hardware/nvidia
    ../../../modules/system/hardware/logitech
    ../../../modules/system/hardware/printing.nix
    ../../../modules/system/apps/steam
    ../../../modules/system/services/tg-ws-proxy.nix
    ../../../modules/system/services/n8n.nix
    ../gui
    ../apps-common.nix
    ../network-bypass.nix
    ./audio.nix
    ./networking.nix
    ./users.nix
    ./virtualization.nix
    ./secrets.nix
    ./zapret.nix
  ];

  # NVIDIA + Zen browser specific portal override: RemoteDesktop must go
  # through the gnome portal instead of wlr on this machine.
  xdg.portal.config.niri."org.freedesktop.impl.portal.RemoteDesktop" = lib.mkForce ["gnome"];

  environment.systemPackages = with pkgs; [
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
