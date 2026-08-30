{ userName, ...}: {
  local.networking.singBox.configPath = "/home/${userName}/.config/secrets/sing-box.json";
  local.networking.n8n.envFile = "/home/${userName}/.config/secrets/n8n.env";
}
