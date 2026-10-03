{ pkgs, ... }:
{
  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 3069;
    hostname = "0.0.0.0";
  };
  services.ollama = {
    enable = true;
    package = pkgs.ollama.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.zstd ];
      postFixup = (old.postFixup or "") + ''
        tar --zstd -xf ${
          pkgs.fetchurl {
            url = "https://github.com/ollama/ollama/releases/download/v${old.version}/ollama-linux-arm64-jetpack5.tar.zst";
            hash = "sha256-xEXJv/uUOJNKZPware3rDwOBQM/bB9EbxaMS557kp/Q=";
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
