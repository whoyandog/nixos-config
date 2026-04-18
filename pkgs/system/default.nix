{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    git
    ouch

    # file manager
    yazi
    thunar
    
    # file systems
    ntfs3g

    # audio control
    pavucontrol

    # AI
    aider-chat
  ];
}
