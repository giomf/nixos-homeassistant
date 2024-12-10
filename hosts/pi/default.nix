{ lib, pkgs, ... }:

{
  imports = [
    ./bsp.nix
    ../../common
    ./network.nix
  ];

  boot.supportedFilesystems.zfs = lib.mkForce false;
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.05";
  environment.systemPackages = with pkgs; [ libraspberrypi ];
  environment.defaultPackages = with pkgs; [ ];
  sdImage.compressImage = false;

  # # Fix for https://github.com/NixOS/nixpkgs/issues/154163
  # nixpkgs.overlays = [
  #   (final: super: {
  #     makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  #   })
  # ];
}
