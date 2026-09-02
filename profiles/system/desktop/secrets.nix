{ userName, ...}: {
  local.networking.n8n.envFile = "/home/${userName}/.config/secrets/n8n.env";
}
