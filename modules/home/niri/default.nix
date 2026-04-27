{ config, pkgs, ... }: {
	xdg.configFile."niri/config.kdl".source = ./config.kdl;

	home.packages = [
		pkgs.playerctl
	];

	gtk = {
		enable = true;
		gtk4.theme = config.gtk.theme;

		gtk3.extraConfig = {
			gtk-application-prefer-dark-theme = 1;
		};

		gtk4.extraConfig = {
			gtk-application-prefer-dark-theme = 1;
		};
	};

	# qt = {
	# 	 enable = true;
	# };

	# home.sessionVariables = {
		# QT_QPA_PLATFORM = "wayland;xcb";
	# };
}

