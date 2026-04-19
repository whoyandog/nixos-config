{ pkgs, ... }: {
	xdg.configFile."niri/config.kdl".source = ./config.kdl;

	gtk = {
		enable = true;
		theme = {
			name = "Adwaita-dark";
			package = pkgs.gnome-themes-extra;
		};
		gtk4.theme = {
			name = "Adwaita-dark";
			package = pkgs.gnome-themes-extra;
		};
		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};

		gtk3.extraConfig = {
			gtk-application-prefer-dark-theme = 1;
		};

		gtk4.extraConfig = {
			gtk-application-prefer-dark-theme = 1;
		};
	};

	dconf.settings = {
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
			gtk-theme = "Adwaita-dark";
			icon-theme = "Papirus-Dark";
		};
	};

	qt = {
		enable = true;
	};

	home.sessionVariables = {
		GTK_THEME = "Adwaita:dark";
		QT_QPA_PLATFORM = "wayland;xcb";
	};
}

