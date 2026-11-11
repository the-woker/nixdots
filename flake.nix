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

    fibpass = {
      url = "github:the-woker/fibpass";
    };

    neko = {
      url = "github:the-woker/neko-mangowm";
    };

    configs = {
      url = "github:the-woker/configs/main";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nix-flatpak,
      mangowm,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      lib = inputs.nixpkgs.lib;
      mkHost =
        host: disks:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs disks;
            settings = import ./hosts/${host}/settings.nix;
          };
          modules = [
            ./hosts/${host}
          ];
        };

      mkHome =
        host:
        let
          settings = import ./hosts/${host}/settings.nix;
        in
        (import ./modules/home {
          inherit inputs pkgs settings;
        }).${settings.name};
    in
    {
      nixosConfigurations = {
        desktop = mkHost "desktop" [ "/dev/nvme0n1" ];
        thinkpad = mkHost "thinkpad" [ "/dev/nvme0n1" ]; # <-- Adjust ThinkPad's drive path if needed
      };

      homeConfigurations = {
        "ratjerky@desktop" = mkHome "desktop";
        "ratjerky@thinkpad" = mkHome "thinkpad";
      };
    };
}
