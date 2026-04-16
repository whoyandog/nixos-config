{ pkgs, inputs, ...}: 
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    fuzzel
    wl-clipboard

    # wallpapers
    swww

    # browsers
    qutebrowser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # obsidian
    obsidian
  ];
}

