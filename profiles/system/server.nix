{...}: {
  # Headless home-server profile: no GUI/niri/stylix, no NVIDIA/gamedev
  # profiles. Networking services for password storage (Vaultwarden) and
  # Obsidian LiveSync (CouchDB) are planned but intentionally not wired up
  # yet -- they depend on migrating data off the current Ubuntu box first.
  #
  # See modules/system/networking/{mosquitto,n8n}.nix for other optional
  # services that already exist in the repo but are disabled everywhere
  # for now.

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
