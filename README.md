# nixpi
Personal nixos configuration for raspberry pi

# Make an sd image
```shell
nix build .#nixosConfigurations.nixpi.config.system.build.sdImage
```
