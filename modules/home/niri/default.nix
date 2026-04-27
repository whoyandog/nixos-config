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

	systemd.user.services.xwayland-satellite = {
		Unit = {
			Description = "Xwayland outside the compositor";
			After = [ "graphical-session.target" ];
			PartOf = [ "graphical-session.target" ];
		};

		Service = {
			Type = "simple";
			ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
			Restart = "on-failure";
			RestartSec = 2;
		};

		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};

	systemd.user.services.solaar = {
		Unit = {
			Description = "Solaar background process";
			After = [ "graphical-session.target" ];
			PartOf = [ "graphical-session.target" ];
		};

		Service = {
			Type = "simple";
			ExecStart = "${pkgs.solaar}/bin/solaar -w hide";
			Restart = "on-failure";
			RestartSec = 2;
		};

		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};

	systemd.user.services.awww-daemon = {
		Unit = {
			Description = "Awww wallpaper daemon";
			After = [ "graphical-session.target" ];
			PartOf = [ "graphical-session.target" ];
		};

		Service = {
			Type = "simple";
			ExecStart = "${pkgs.awww}/bin/awww-daemon";
			Restart = "on-failure";
			RestartSec = 2;
		};

		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};
}

