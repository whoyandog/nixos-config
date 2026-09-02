{pkgs, ...}: {
  local.networking.singBox.configPath = "/home/${userName}/.config/secrets/sing-box.json";

  imports = [
    ../../modules/system/networking/sing-box.nix
  ];

  environment.systemPackages = with pkgs; [
    sing-box
  ];
}
