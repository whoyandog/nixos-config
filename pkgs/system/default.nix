{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    git
    ouch

    # file manager
    yazi

    # file systems
    ntfs3g
    thunar
  ];
}
