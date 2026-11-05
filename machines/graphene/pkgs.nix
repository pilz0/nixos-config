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
      mitmproxy
      nil
      nixfmt
      speedtest-cli
      python3
      terraform
      cmatrix
      openconnect
      gnupg
      kubectl
      android-tools # adb to the phone itself via wireless debugging
      github-copilot-cli
      antigravity-cli
      claude-code
      rustup

      # gui, for desktop mode (see ./desktop.nix)
      alacritty
      firefox
      mpv
      vesktop
      wireshark
      drawio
      filezilla
      zotero
    ])
    ++ [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
