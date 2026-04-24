{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    git
    ouch

    usbutils

    # internet utils
    bind 

    # system utils
    screenfetch

    # vnc wayland client
    wlvncc

    # file manager
    yazi
    thunar
    
    # file systems
    ntfs3g

    # audio control
    pavucontrol
    pulseaudio
    easyeffects

    # steam/graphics runtime tools
    xwayland-satellite
    vulkan-loader
    vulkan-tools

    # bypass/proxy stack
    sing-box
    proxychains-ng

    # peripherals
    solaar
    headsetcontrol

    # AI
    aider-chat
  ];
}
