{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.config.permittedInsecurePackages = [ "firefox-esr-140-bin-unwrapped-140.17.0esr" ];

  environment.systemPackages =
    (with pkgs; [
      # cli
      nil
      nixfmt
      speedtest-cli
      python3
      cmatrix
      openconnect
      gnupg
      android-tools # adb to the phone itself via wireless debugging
      antigravity-cli
      claude-code
    ])
    ++ [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}
