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
      preBuild = builtins.replaceStrings [ "cuda_v11" ] [ "cuda_jetpack5" ] old.preBuild;
    });
    loadModels = [
      "gemma4:e4b"
    ];
  };

  systemd.services.ollama.serviceConfig = {
    DeviceAllow = [
      "/dev/nvmap"
      "/dev/nvhost-ctrl"
      "/dev/nvhost-ctrl-gpu"
      "/dev/nvhost-gpu"
      "/dev/nvhost-as-gpu"
      "/dev/nvhost-tsg-gpu"
      "/dev/nvhost-nvsched-gpu"
      "/dev/nvhost-power-gpu"
    ];
    SupplementaryGroups = [ "video" ];
  };
}
