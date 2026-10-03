{ pkgs, ... }:
let
  jetson-ffmpeg = pkgs.callPackage ../../pkgs/jetson-ffmpeg.nix { };

  # the tegra encoder/decoder is only reachable through nvidia's multimedia api (nvmpi),
  # none of the hwaccels in stock jellyfin-ffmpeg work on a jetson
  ffmpeg-nvmpi = pkgs.jellyfin-ffmpeg.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ jetson-ffmpeg ];
    configureFlags = old.configureFlags ++ [ "--enable-nvmpi" ];
    postPatch = (old.postPatch or "") + ''
      cp -r ${jetson-ffmpeg.src} nvmpi
      chmod -R u+w nvmpi
      (cd nvmpi && bash ./ffpatch.sh "$OLDPWD")
      rm -r nvmpi
    '';
  });

  # jellyfin has no nvmpi option, so it is set to v4l2 and the codec names get swapped here.
  # ffmpeg links the stock libv4l2, nvmpi only works with nvidia's build of it (same soname)
  wrapper = pkgs.writeShellScript "ffmpeg" ''
    args=("''${@//_v4l2m2m/_nvmpi}")
    # jellyfin's hevc profile/level values are not ones nvmpi understands, the encoder picks its own
    if [[ " ''${args[*]} " == *" hevc_nvmpi "* ]]; then
      keep=()
      for ((i = 0; i < ''${#args[@]}; i++)); do
        case ''${args[i]} in
          -profile:v:0 | -level) ((i++)) ;;
          *) keep+=("''${args[i]}") ;;
        esac
      done
      args=("''${keep[@]}")
    fi
    LD_PRELOAD=${pkgs.nvidia-jetpack.l4t-multimedia}/lib/libnvv4l2.so exec ${ffmpeg-nvmpi}/bin/ffmpeg "''${args[@]}"
  '';

  ffmpeg = pkgs.symlinkJoin {
    name = "jellyfin-ffmpeg-nvmpi";
    paths = [ ffmpeg-nvmpi ];
    postBuild = ''
      rm $out/bin/ffmpeg
      install -m755 ${wrapper} $out/bin/ffmpeg
    '';
  };

  # v4l2 mode only knows the h264 encoder, without this hevc always falls back to libx265
  jellyfin = (pkgs.jellyfin.override { jellyfin-ffmpeg = ffmpeg; }).overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace MediaBrowser.MediaEncoding/Encoder/EncoderValidator.cs \
        --replace-fail '"h264_v4l2m2m",' '"h264_v4l2m2m", "hevc_v4l2m2m",'
    '';
  });
in
{
  services.jellyfin = {
    package = jellyfin;
    hardwareAcceleration = {
      enable = true;
      type = "v4l2m2m";
      device = "/dev/nvhost-msenc";
    };
    transcoding = {
      enableHardwareEncoding = true;
      hardwareEncodingCodecs.hevc = true;
    };
    # encoding.xml already exists, without this the settings above are never written
    forceEncodingConfig = true;
  };

  systemd.services.jellyfin.serviceConfig = {
    # hardwareAcceleration.enable only allows its one device, the encoder needs these too
    DeviceAllow = [
      "/dev/nvmap"
      "/dev/nvhost-ctrl"
      "/dev/nvhost-nvenc1"
      "/dev/nvhost-vic"
      "/dev/l3cache"
      "/dev/nvgpu/igpu0/ctrl"
      "/dev/nvgpu/igpu0/power"
    ];
    # the nodes above are root:video
    SupplementaryGroups = [ "video" ];
  };
}
