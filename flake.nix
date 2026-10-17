{
  description = "NixOS configurations for XPS13 and GTi13-Ultra";

  inputs = {
    # General
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-combined = {
      url = "git+https://github.com/nix-community/nur-combined?ref=refs/heads/main&shallow=1";
      flake = false;
    };

    # System
    goodix53x5 = {
      url = "github:AndyHazz/goodix53x5-libfprint/main";
      flake = false;
    };

    # Desktop
    gdm-extension = {
      url = "git+https://github.com/PRATAP-KUMAR/gse-gdm-extension?ref=main&shallow=1";
      flake = false;
    };
    catppuccin-tilix = {
      url = "git+https://github.com/catppuccin/tilix?ref=main&shallow=1";
      flake = false;
    };
    catppuccin-ulauncher = {
      url = "git+https://github.com/catppuccin/ulauncher?ref=main&shallow=1";
      flake = false;
    };
    ulauncher-system = {
      url = "git+https://github.com/tjquillan/ulauncher-system?ref=master&shallow=1";
      flake = false;
    };

    # Application
    nixvim.url = "github:nix-community/nixvim/2c6d56d2df7c159ef629871cfd673de237e1fc38";
    zen-browser = {
      url = "git+https://github.com/0xc000022070/zen-browser-flake?ref=refs/tags/1.24t-1790962255&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    spicetify = {
      url = "git+https://github.com/Gerg-L/spicetify-nix?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      sharedLib = import ./lib { lib = inputs.nixpkgs.lib; };
      editor = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        module = import ./modules/application/development/neovim/config;
      };
    in
    {
      packages.x86_64-linux = {
        nixvim = editor;
        default = editor;
      };
      checks.x86_64-linux = {
        nixvim = inputs.nixvim.lib.x86_64-linux.check.mkTestDerivationFromNvim {
          name = "nixvim";
          nvim = editor;
        };
      };
      nixosConfigurations.xps13 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs sharedLib;
          targetUser = "zesty";
        };
        modules = [
          inputs.nixvim.nixosModules.nixvim
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs sharedLib;
              targetUser = "zesty";
            };
          }
          ./hosts/xps13
        ];
      };

      nixosConfigurations.gti13-ultra = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs sharedLib;
          targetUser = "zesty";
        };
        modules = [
          inputs.nixvim.nixosModules.nixvim
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs sharedLib;
              targetUser = "zesty";
            };
          }
          ./hosts/gti13-ultra
        ];
      };
    };
}
