# nixpi
Personal nixos configuration for raspberry pi

# Make an sd image
```shell
<nix,nom> build .#nixosConfigurations.nixpi.config.system.build.sdImage
```
# Build the flake locally
```
<nix,nom> build .#nixosConfigurations.nixpi.config.system.build.toplevel
```
