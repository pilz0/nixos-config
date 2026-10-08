{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.pilz.darwin.pkgs;
in
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
  options.pilz.darwin.pkgs = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        ansible
        tmux
        vim
        fastfetch
        zsh
        nmap
        git
        btop
        wget
        rclone
        restic
        gtop
        freerdp
        killall
        picocom
        gnumake
        curl
        dig
        wireguard-tools
        colmena
        stats
        git-lfs
        openssl
        pwgen
        uv
        jq
        yq
        google-chrome
        openvpn
        dash
        nil
        nixd
        python314
        gh
        docker
        docker-compose
        colima
        metasploit
        postgresql_18
        mitmproxy
        wireshark
        devenv
        zotero
        androidenv.androidPkgs.ndk-bundle
        cargo-ndk
        rustc
        rustup
        xld
        firefox
        cyberduck
        comma
        android-tools
      ])
      ++ [
        inputs.agenix.packages.aarch64-darwin.default
      ]
      ++ (with pkgs-unstable; [
        caffeine
        direnv
        #istat-menus
        github-copilot-cli
        mpv-unwrapped
        daisydisk
        spotify
        antigravity-cli
        claude-code
      ]);
    homebrew = {
      taps = builtins.attrNames config.nix-homebrew.taps;
      casks = [
        "android-studio"
      ];
    };
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "pilz";
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
      trust = {
        formulae = [ ];
        casks = [ ];
        commands = [ ];
        taps = [ ];
      };
    };
  };
}
