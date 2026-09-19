{...}: {
  programs.git = {
    enable = true;
    userName = "whoyandog";
    userEmail = "dimka360@mail.ru";
    settings = {
      user.useConfigOnly = true;
      init.defaultBranch = "main";
    };
  };
}
