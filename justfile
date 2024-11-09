# To be used in the raspi to build and switch config
doit action='switch':
  nh os {{action}} .

# To build the system locally
build:
  nom build .#nixosConfigurations.nixpi.config.system.build.toplevel

# To build the system and make a sd image.
mksd:
  nom build .#nixosConfigurations.nixpi.config.system.build.sdImage
