{
  config,
  pkgs,
  ...
}: {
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_family = "JetBrains Mono";
          placeholder_text = "<i>Password...</i>";
          hide_input = false;

          outline_thickness = 2;
          outer_color = "rgb(180, 190, 254)";
          inner_color = "rgb(30, 30, 46)";
          font_color = "rgb(205, 214, 244)";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 80;
          font_family = "JetBrains Mono";
          position = "0, 80";
          valign = "center";
          halign = "center";
          color = "rgb(205, 214, 244)";
        }
      ];
    };
  };
}
