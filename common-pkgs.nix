{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    ansible
    awscli
    kubernetes
    kind
    doctl
    ktop
    htop
    tmux
    busybox
    prometheus
    unzip
    vim
    fastfetch
    neofetch
    zsh
    nmap
    hyfetch
    go
    lshw
    traceroute
    speedtest-cli
    rustc
    pciutils
    git
    metasploit
    ecryptfs
    gnumake
    wireshark-qt
    superTuxKart
    cargo
    gcc
    cron
    vlc
    alacritty
    cmatrix
    btop
    gitlab-runner
    wget
    rclone
    restic
    gtop
    freerdp
    killall
    picocom
    dnsmasq
    spotifyd
    pipes
    nvidia-docker
    htop
    nvtopPackages.nvidia
    procps
    gnumake
    m4
    cudatoolkit
    linuxPackages.nvidia_x11
    libGLU
    libGL
    xorg.libXi
    xorg.libXmu
    freeglut
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
    zlib
    ncurses5
    stdenv.cc
    binutils
    curl
    ddclient
    docker-compose
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    dig
    wireguard-tools
    qemu
    python312Packages.flask
    md2pdf
    python312Packages.python-dotenv
    python312Packages.pytz
  ];
}
