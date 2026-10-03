{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jetson-stats";
  version = "7.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rbonghi";
    repo = "jetson_stats";
    tag = finalAttrs.version;
    hash = "sha256-qsvtj9rkbRLQSmG9tQMACALij0yOkvrjmgc4UPS5ZVk=";
  };

  # upstream keeps its config in sys.prefix, which is the read-only nix store
  postPatch = ''
    substituteInPlace jtop/core/config.py \
      --replace-fail 'return "{path}/{data_folder}".format(path=path, data_folder=data_folder)' 'return "/var/lib/jtop"'
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    smbus2
    distro
    nvidia-ml-py
  ];

  doCheck = false;
  pythonImportsCheck = [ "jtop" ];

  meta = with lib; {
    description = "System monitor and process viewer for NVIDIA Jetson (jtop)";
    mainProgram = "jtop";
    homepage = "https://github.com/rbonghi/jetson_stats";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ pilz0 ];
    platforms = platforms.linux;
  };
})
