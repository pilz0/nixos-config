{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    cudatoolkit
    linuxPackages.nvidia_x11
    libGLU
    libGL
    nvidia-docker
    htop
    nvtopPackages.nvidia
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

  ];
}
