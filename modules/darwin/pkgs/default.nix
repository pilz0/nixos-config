{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.darwin.pkgs;
in
{
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
        cyberduck
      ])
      ++ (with pkgs-unstable; [
        caffeine
        direnv
        #istat-menus
        github-copilot-cli
        mpv-unwrapped
        firefox
        daisydisk
        spotify
        antigravity-cli
        claude-code
      ]);
  };
}
