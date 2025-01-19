{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions =
        with vscode-extensions;
        [
          bbenoist.nix
          jnoortheen.nix-ide
          eamodio.gitlens
          hashicorp.terraform
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }
          {
            name = "catppuccin-vsc";
            publisher = "Catppuccin";
            version = "3.16.0";
            sha256 = "eZwi5qONiH+XVZj7u2cjJm+Liv1q07AEd8d4nXEQgLw=";
          }
          {
            name = "copilot";
            publisher = "GitHub";
            version = "1.257.0";
            sha256 = "QnxVfz1r+su6YXaHBIoKz1e5yklh/SrKKsPUNyv2YHM=";
          }
        ];
    })
  ];
}
