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

    yandex-music = {
      url = "github:whoyandog/yandex-music-app";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkHost = hostName: userName: 
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs hostName userName;};
        modules = [
          ./hosts/${hostName}/default.nix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              (final: prev: {
                mpris-mqtt-adapter = final.callPackage ./pkgs/mpris-mqtt-adapter.nix {
                  src = inputs.mpris-mqtt-adapter-src;
                };
                tg-ws-proxy = final.callPackage ./pkgs/tg-ws-proxy.nix {};
              })
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs hostName userName;};
            home-manager.users.${userName} = import ./profiles/user/default.nix;
          }
        ];
      };
  in {
    nixosConfigurations = let
      userName = "dmitry";
      mkUserHost = hostName: mkHost hostName userName;
    in {
      workstation = mkUserHost "workstation";
      tablet  = mkUserHost "tablet";
      server  = mkUserHost "server";
    };
  };
}
