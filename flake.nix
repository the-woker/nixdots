{
  description = "NixOS + Home Manager + NVF + MangoWM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    newp = {
      url = "git+https://codeberg.org/woker/nix-cpp-template";
    };

  };

  outputs =
    {
      nixpkgs,
      nix-flatpak,
      nvf,
      mangowm,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      lib = inputs.nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./modules
          ];
        };
        live = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            inputs.sops-nix.nixosModules.sops
            ./modules/system/core.nix
            ./modules/system/users.nix
            ./modules/system/wireless.nix
            ./modules/system/packages.nix
            ./modules/system/secrets.nix
            ./modules/system/ssh.nix
            ./modules/system/vm.nix
            {
              networking.hostName = lib.mkForce "live";
              boot.zfs.forceImportRoot = false;
              services.getty.autologinUser = lib.mkForce "nick";
              programs.zsh.enable = true;
              users.users.nick.hashedPasswordFile = lib.mkForce null;
              users.users.nick.initialPassword = lib.mkForce "nixos";
            }
          ];
        };
        live-vm = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            ./modules/system/core.nix
            ./modules/system/users.nix
            ./modules/system/ssh.nix
            ./modules/system/packages.nix
            ./modules/system/secrets.nix
            ./modules/home
            {
              programs.zsh.enable = true;
              networking.hostName = "live";
              services.openssh.enable = true;

              users.users.nick.initialPassword = "nixos";
            }

            {
              virtualisation.vmVariant = {
                virtualisation.forwardPorts = [
                  {
                    from = "host";
                    host.port = 2222;
                    guest.port = 22;
                  }
                ];
              };
            }
          ];
        };
      };
    };
}
