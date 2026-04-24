{ ... }: {
  programs.kitty = {
    enable = true;

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+с" = "copy_to_clipboard";

      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+м" = "paste_from_clipboard";

      # Keyboard-only selection from visible terminal output.
      "ctrl+shift+e" = "kitten hints --type word --program @";
      "ctrl+shift+у" = "kitten hints --type word --program @";
      "ctrl+shift+g" = "kitten hints --type line --program @";
      "ctrl+shift+п" = "kitten hints --type line --program @";
    };
  };
}
