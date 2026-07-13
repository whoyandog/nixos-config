{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop

    # nekoray
    throne
  ];
}
