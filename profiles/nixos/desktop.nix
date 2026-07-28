{ pkgs, inputs, ...}: 
{
  environment.systemPackages = with pkgs; [
    kitty
    fuzzel
    wl-clipboard
    
    # wallpapers
    awww

    # browsers
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    qutebrowser

    # obsidian
    obsidian

    # telegram
    telegram-desktop

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

