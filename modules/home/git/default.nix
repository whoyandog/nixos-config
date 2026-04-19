{ ... }: {
	programs.git = {
		enable = true;
		settings = {
			user.useConfigOnly = true;
			init.defaultBranch = "main";
		};
		includes = [
			{ path = "~/.config/git/identity.inc"; }
		];
	};
}
