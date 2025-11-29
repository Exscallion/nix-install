{
  description = "My NixOS install";
  inputs = {
    nixpkgs = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github.com:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follow = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, ... } @inputs:
  let 
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        (
          {
            config,
            pkgs,
            ...
          }:
          {
            nixpkgs.config.allowUnfree = true;
          }
        )
        ./hosts/default/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
