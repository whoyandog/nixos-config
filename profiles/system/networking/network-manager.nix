{ userName, ... }:

{
  networking.networkmanager.enable = true;
  users.users.${userName}.extraGroups = [ "networkmanager" ];
}