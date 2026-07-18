{ ... }:
{
  users.users.dmitry = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
