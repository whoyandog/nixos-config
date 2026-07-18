{
  description = "NixOS configuration with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    mpris-mqtt-adapter-src = {
      url = "github:whoyandog/mpris-mqtt-adapter";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs: {
    nixosConfigurations."pc-dmitry" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        ./hosts/pc-dmitry/default.nix 
        inputs.stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager 
        {
          nixpkgs.overlays = [
            (final: prev: {
              mpris-mqtt-adapter = final.callPackage ./pkgs/mpris-mqtt-adapter.nix {
                src = inputs.mpris-mqtt-adapter-src;
              };
              tg-ws-proxy = final.callPackage ./pkgs/tg-ws-proxy.nix { };
            })
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.dmitry = {
            imports = [
              ./home/dmitry.nix
              ./profiles/home/base.nix
              ./profiles/home/dev.nix
              ./profiles/home/mpris-mqtt-adapter.nix
              ./modules/home/cursor
              ./modules/home/kitty
              ./modules/home/neovim
              ./modules/home/niri
              ./modules/home/git
              ./modules/home/waybar
              ./modules/home/mpris-mqtt-adapter
              ./modules/home/dbox-browser.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations."tablet-dmitry" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        ./hosts/tablet-dmitry/default.nix 
        inputs.stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager 
        {
          # overlays, etc. for tablet if needed

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.dmitry = {
            imports = [
              ./home/dmitry.nix
              ./profiles/home/base.nix
              ./modules/home/git
              ./modules/home/neovim
              # tablet specific stuff
            ];
          };
        }
      ];
    };

    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        ./hosts/server/default.nix
        home-manager.nixosModules.home-manager 
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.dmitry = {
            imports = [
              ./home/dmitry.nix
              ./profiles/home/base.nix
              ./modules/home/git
              ./modules/home/neovim
            ];
          };
        }
      ];
    };
  };
}
