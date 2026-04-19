{ pkgs, inputs, ...}: 
{
  environment.systemPackages = with pkgs; [
    kitty
    fuzzel
    wl-clipboard

    # wallpapers
    awww

    # browsers
    qutebrowser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # obsidian
    obsidian
  ];
}

