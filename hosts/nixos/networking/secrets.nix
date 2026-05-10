{ ... }:
{
  local.networking.singBox.configPath = "/home/dmitry/.config/secrets/sing-box.json";
  local.networking.n8n.enable = true;
  local.networking.n8n.envFile = "/home/dmitry/.config/secrets/n8n.env";
}
