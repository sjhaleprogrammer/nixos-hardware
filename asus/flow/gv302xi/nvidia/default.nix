{ lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../shared.nix
    ## "prime.nix" loads this, aleady:
    # ../../../common/gpu/nvidia
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/ada-lovelace

  ];

  # NVIDIA GeForce RTX 4070 Mobile

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
  };

  # Also in nvidia/default.nix
  services.xserver.videoDrivers = mkDefault [ "nvidia" ];

  hardware = {
    ## Enable the Nvidia card, as well as Prime and Offload:
    amdgpu.initrd.enable = mkDefault true;

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = mkDefault true;

      prime = {
        offload = {
          enable = mkDefault true;
          enableOffloadCmd = mkDefault true;
        };
        amdgpuBusId = "PCI:69:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      dynamicBoost.enable = true;
      
    };
  };
}