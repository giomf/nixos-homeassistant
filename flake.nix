{
  description = "System flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pi-bsp = {
      url = "github:nix-community/raspberry-pi-nix/refs/tags/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs =
    {
      nixpkgs,
      pi-bsp,
      flake-utils,
      home-manager,
      agenix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        # Define development shells
        devShells.default = pkgs.mkShell {
          buildInputs = [
            agenix.packages.x86_64-linux.default
          ];
        };
      }
    )
    // rec {
      nixosConfigurations = {
        "homeassistant" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            # {
            #   nixpkgs.crossSystem = {
            #     # target platform
            #     system = "aarch64-linux";
            #   };
            # }
            ./hosts/pi
            pi-bsp.nixosModules.raspberry-pi
            # Needed in next release of raspberry-pi-nix
            # pi-bsp.nixosModules.sd-image
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.guif = ./hosts/pi/home.nix;
            }
          ];
        };
      };
      images.homeassistant = nixosConfigurations.homeassistant.config.system.build.sdImage;
    };
}
