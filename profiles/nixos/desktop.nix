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
  ];
}

