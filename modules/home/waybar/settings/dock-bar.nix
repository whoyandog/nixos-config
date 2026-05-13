{
  name = "dock";
  layer = "top";
  position = "bottom";
  exclusive = true;
  fixed-center = true;
  width = 320;
  margin-bottom = 14;

  modules-left = [ ];
  modules-center = [
    "custom/app-zen-beta"
    "custom/app-thunar"
    "custom/app-vscode"
    "custom/app-steam"
    "custom/app-obsidian"
  ];
  modules-right = [ ];

  "custom/app-zen-beta" = {
    format = " ";
    tooltip = false;
    on-click = "zen-beta";
  };

  "custom/app-thunar" = {
    format = " ";
    tooltip = false;
    on-click = "thunar";
  };

  "custom/app-vscode" = {
    format = " ";
    tooltip = false;
    on-click = "code";
  };

  "custom/app-steam" = {
    format = " ";
    tooltip = false;
    on-click = "steam";
  };

  "custom/app-obsidian" = {
    format = " ";
    tooltip = false;
    on-click = "obsidian";
  };
}
