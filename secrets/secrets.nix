let
  ando_thunderdome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjZq6GCEU+TpzLRthwvjzN6pPO+gJt2ngakYpxycf+y";
  root_nixpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEqqDVfoH+P9saryI34gsYrZXwtWF/oJKFZcUKs0W8p";

  public_keys = [
    ando_thunderdome
    root_nixpi
  ];
in
{
  "nixpi-hashed-password.age".publicKeys = public_keys;
  "wireless.conf".publicKeys = public_keys;
  "wg-easy.env".publicKeys = public_keys;
}
