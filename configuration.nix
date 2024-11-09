{
  config,
  pkgs,
  nixpkgs,
  ...
}:
{
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  age.secrets = {
    "nixpi-hashed-password.age".file = ./secrets/nixpi-hashed-password.age;
    "wireless.conf".file = ./secrets/wireless.conf;
    "wg-easy.env".file = ./secrets/wg-easy.env;
  };

  networking = {
    hostName = "nixpi";
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      # Use following for first time setup
      # networks."nsa_surveillance".psk = "<ENTER-PASSWORD-FIRST-TIME>";
      secretsFile = config.age.secrets."wireless.conf".path;
      networks."nsa_surveillance".pskRaw = "ext:password";
    };
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    nh
  ];

  users = {
    mutableUsers = false;
    users."ando" = {
      isNormalUser = true;
      # Use following for first time setup
      # password = "<USER-PASSWORD>";
      hashedPasswordFile = config.age.secrets."nixpi-hashed-password.age".path;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjZq6GCEU+TpzLRthwvjzN6pPO+gJt2ngakYpxycf+y ando@thunderdome"
      ];
      packages = with pkgs; [
        fastfetch
        just
      ];
    };
  };

  virtualisation.oci-containers.containers = {
    "wg-easy" = {
      image = "ghcr.io/wg-easy/wg-easy";
      volumes = [ "wg-easy:/etc/wireguard" ];
      environmentFiles = [ config.age.secrets."wg-easy.env".path ];
      ports = [
        "51820:51820/udp"
        "51821:51821/tcp"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_MODULE"
        "--cap-add=NET_RAW"
        "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
        "--sysctl=net.ipv4.ip_forward=1"
      ];
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Don't change this unless you know what you're doing
  system.stateVersion = "24.05";
}
