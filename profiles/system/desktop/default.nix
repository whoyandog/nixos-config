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

  environment.systemPackages = with pkgs; [
    # wallpapers
    awww


    # yandex music

    # graphic redactor

    # discord

    # libreoffice
  ];

}
