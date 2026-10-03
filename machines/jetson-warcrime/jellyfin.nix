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

  # jellyfin has no nvmpi option, so it is set to v4l2 and the codec names get swapped here
  ffmpeg = pkgs.symlinkJoin {
    name = "jellyfin-ffmpeg-nvmpi";
    paths = [ ffmpeg-nvmpi ];
    postBuild = ''
      rm $out/bin/ffmpeg
      cat > $out/bin/ffmpeg <<'EOF'
      #!${pkgs.runtimeShell}
      exec ${ffmpeg-nvmpi}/bin/ffmpeg "''${@//_v4l2m2m/_nvmpi}"
      EOF
      chmod +x $out/bin/ffmpeg
    '';
  };
in
{
  services.jellyfin = {
    package = pkgs.jellyfin.override { jellyfin-ffmpeg = ffmpeg; };
    hardwareAcceleration.type = "v4l2m2m";
    # encoding.xml already exists, without this the type above is never written
    forceEncodingConfig = true;
  };

  # /dev/nvhost-* and /dev/nvmap are root:video
  systemd.services.jellyfin.serviceConfig.SupplementaryGroups = [ "video" ];
}
