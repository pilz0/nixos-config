{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nvidia-jetpack,
}:

stdenv.mkDerivation {
  pname = "jetson-ffmpeg";
  version = "0-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "Keylost";
    repo = "jetson-ffmpeg";
    rev = "64df5aa2eead76bfc749359481585dea1c582237";
    hash = "sha256-4EME6eqGvBp1URSluDRHtBZ7EvCURjnchmmn+D+sVSM=";
  };

  nativeBuildInputs = [ cmake ];

  # l4t-multimedia ships the multimedia api headers and sample classes next to the libs
  cmakeFlags = [
    "-DJETSON_MULTIMEDIA_API_DIR=${nvidia-jetpack.l4t-multimedia}"
    "-DJETSON_MULTIMEDIA_LIB_DIR=${nvidia-jetpack.l4t-multimedia}/lib"
    # cmake drops the build rpath on install, without it nothing can link against libnvmpi
    "-DCMAKE_INSTALL_RPATH=${nvidia-jetpack.l4t-multimedia}/lib"
  ];

  meta = with lib; {
    description = "libnvmpi, the L4T multimedia api wrapper used by ffmpeg's nvmpi codecs";
    homepage = "https://github.com/Keylost/jetson-ffmpeg";
    license = licenses.mit;
    maintainers = with maintainers; [ pilz0 ];
    platforms = [ "aarch64-linux" ];
  };
}
