{ pkgs, ... }:
{
  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 3069;
    hostname = "0.0.0.0";
  };
  services.ollama = {
    enable = true;
    # nixpkgs ollama has no CUDA 11 backend; GPU support comes from the prebuilt jetpack5 runner below
    package = (pkgs.ollama.override { acceleration = false; }).overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.zstd ];
      postFixup = (old.postFixup or "") + ''
        tar --zstd -xf ${
          pkgs.fetchurl {
            url = "https://github.com/ollama/ollama/releases/download/v${old.version}/ollama-linux-arm64-jetpack5.tar.zst";
            hash = "sha256-a1N2yCsW6ioOdVB5u1i3Ip/oyiRsN0AcT88QZKqv+bQ=";
          }
        } -C $out
        for f in $out/lib/ollama/cuda_jetpack5/*.so*; do
          [ -L "$f" ] || patchelf --add-rpath ${
            pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.glibc
            ]
          }:/run/opengl-driver/lib "$f"
        done
      '';
    });
    loadModels = [
      "gemma4:e4b"
    ];
  };

  systemd.services.ollama.serviceConfig = {
    DeviceAllow = [
      "/dev/nvmap"
      "/dev/nvhost-ctrl"
      "/dev/l3cache"
      "/dev/nvgpu/igpu0/ctrl"
      "/dev/nvgpu/igpu0/power"
    ];
    SupplementaryGroups = [ "video" ];
  };
}
