# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "lvvvq";
    homeDirectory = "/home/lvvvq";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # utlis
    tmux

    # search
    fzf
    ripgrep
    fd

    # navigate
    zoxide
    ranger

    # archive
    gnutar
    unzip
    atool

    # git
    lazygit
    gh

    # clip
    xclip
    lemonade

    # image
    ueberzug
    feh
    w3m

    # nodejs
    nodejs_20

    # golang
    go

    # java
    jdk11

    # docker
    docker
    lazydocker

    # dev
    unstable.devbox
    gcc
    cmake
    gnumake
    mycli

    # other
    neofetch
    stow
    btop
    bat
    highlight

  ];


  programs = {
    # Enable home-manager
    home-manager.enable = true;

    # neovim
    neovim.enable = true;
    neovim.vimAlias = true;
    neovim.viAlias = true;

    # git
    git.enable = true;
    gh.enable = true;
    git.userName = "lvvvq";
    git.userEmail = "lvvvq@qq.com";

    # fzf
    fzf.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
