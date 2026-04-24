{ ... }: {
  programs.kitty = {
    enable = true;

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+с" = "copy_to_clipboard";

      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+м" = "paste_from_clipboard";
    };
  };
}
