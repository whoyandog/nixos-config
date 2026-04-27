{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    vulkan-loader
    vulkan-tools
  ];
}
