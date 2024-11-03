{config, pkgs, nixpkgs, ...}: {
  system.stateVersion = "24.05"; # Don't change this unless you know what you're doing
  
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  age.secrets = {
    "nixpi-hashed-password.age".file = ./secrets/nixpi-hashed-password.age;
    "wireless.conf".file = ./secrets/wireless.conf;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = ["noatime"];
  };

  networking = {
    hostName = "nixpi";
    wireless = {
      enable = true;
      interfaces = ["wlan0"];
      secretsFile = config.age.secrets."wireless.conf".path;
      networks."nsa_surveillance".pskRaw = "ext:password";
    };
  };

  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    neovim
  ];

  users = {
    mutableUsers = false;
    users."ando" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."nixpi-hashed-password.age".path;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjZq6GCEU+TpzLRthwvjzN6pPO+gJt2ngakYpxycf+y ando@thunderdome"
      ];
      packages = with pkgs; [
        fastfetch
      ];
    };
  };
}
