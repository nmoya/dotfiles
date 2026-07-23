{
    description = "NixOS configuration for nmoya";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
        system = "x86_64-linux";
        unstablePkgs = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
        };
    in
    {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
                inherit unstablePkgs;
            };
            modules = [
                ./system/configuration.nix
                home-manager.nixosModules.home-manager
            ];
        };
    };
}
