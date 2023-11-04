# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # TODO: Set your hostname
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 10;
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    lvvvq = {
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7n8NLxLdhOSPCNAXhtKM07HlYpXFGCDbI71HSyH9w9PsBiSNzXd60UtnMdp2v44Vu/nFx4UJyO7Qa7i3zG94Rz7Vg3fEq+4W315xmPF9gM1FU9mSMrdF7V1GW4GN0x+ogj4/3V5FNBF1AcJoayOqyhB5PxpuSnQDIkxnWD2IOkhZntw1Rz2aB56j8noN3CSJoXw33FNiwScKbtcb8m34v3TsYFcnZsBi67xJmX/rWGtFpjcIQcKxG4Xoe3CqrHiGrZXg9S4+nXVOzu2niEROKLjn91YCJejXJL8PPbcBOel+soW8x6GQXYc2M5eREl1TeGe/2WSV6mXsQO8xwoCLSXtGy0gAD0qmd/SojV6GnZ8aH4PZv6poyl6uEFx/6pvKV5eR+6UMuJy+x7pPuC0g0LNemlk+QUYlgKjpnLyw94+0Jt4g3C1a0cJwH5M4bl50FkS7Nll4JfC7JxU3tZlxNdMeCu4oiVi4MS2Hp31S/huXeDpNtlmZzxyx0dei11AM= #l@LAPTOP-SRL4SVI3"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "docker" "networkmanager"];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    extraConfig = "PrintLastLog no";
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # programs
  programs = {
    # fish
    fish.enable = true;

    # fzf
    fzf.fuzzyCompletion = true;
  };

  # virtualisation
  virtualisation = {
    # docker
    docker.enable = true;

    # vmtool
    vmware.guest.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
