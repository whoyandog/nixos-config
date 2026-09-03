{ userName, ... }: 
{
  imports = [
    ../../../modules/system/services/n8n.nix
  ];

  local.networking.n8n.envFile = "/home/${userName}/.config/secrets/n8n.env";

  local.networking.n8n.enable = true;
}