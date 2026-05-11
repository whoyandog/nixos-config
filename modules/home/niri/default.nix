{ config, pkgs, ... }: {
	xdg.configFile."niri/config.kdl".source = ./config.kdl;

	home.packages = [
		pkgs.playerctl
		pkgs.mpv
		pkgs.loupe
	];

	xdg.mimeApps = {
		enable = true;
		defaultApplications = {
			"x-scheme-handler/http" = [ "zen-beta.desktop" ];
			"x-scheme-handler/https" = [ "zen-beta.desktop" ];
			"text/html" = [ "zen-beta.desktop" ];
			"application/xhtml+xml" = [ "zen-beta.desktop" ];
			"image/jpeg" = [ "org.gnome.Loupe.desktop" ];
			"image/png" = [ "org.gnome.Loupe.desktop" ];
			"image/webp" = [ "org.gnome.Loupe.desktop" ];
			"image/gif" = [ "org.gnome.Loupe.desktop" ];
			"image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
			"video/mp4" = [ "mpv.desktop" ];
			"video/x-matroska" = [ "mpv.desktop" ];
			"video/webm" = [ "mpv.desktop" ];
			"video/x-msvideo" = [ "mpv.desktop" ];
			"audio/mpeg" = [ "mpv.desktop" ];
			"audio/flac" = [ "mpv.desktop" ];
			"audio/ogg" = [ "mpv.desktop" ];
			"audio/mp4" = [ "mpv.desktop" ];
			"audio/x-wav" = [ "mpv.desktop" ];
		};
	};

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

	home.sessionVariables = {
		BROWSER = "zen-beta";
		MOZ_ENABLE_WAYLAND = "1";
	};

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

	systemd.user.services.polkit-authentication-agent = {
		Unit = {
			Description = "Polkit authentication agent";
			After = [ "graphical-session.target" ];
			PartOf = [ "graphical-session.target" ];
		};

		Service = {
			Type = "simple";
			ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			Restart = "on-failure";
			RestartSec = 2;
		};

		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};
}

