{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "whoyandog";
        email = "dimka360@mail.ru";
        useConfigOnly = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
