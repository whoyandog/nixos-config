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

    # steam/graphics runtime tools
    xwayland-satellite
    vulkan-loader
    vulkan-tools

    # bypass/proxy stack
    sing-box
    proxychains-ng

    # peripherals
    solaar

    # AI
    aider-chat
  ];
}
