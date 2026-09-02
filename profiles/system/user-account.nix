{ userName, ...}: {
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
