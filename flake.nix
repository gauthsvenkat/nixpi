{
  description = "nixpi flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
    }:
    {
      nixosConfigurations.nixpi = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit nixpkgs;
        };
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
}
