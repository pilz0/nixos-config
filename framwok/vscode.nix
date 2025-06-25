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
            name = "catppuccin-vsc";
            publisher = "Catppuccin";
            version = "3.17.0";
            sha256 = "udDbsXAEsJUt3WUU8aBvCi8Pu+8gu+xQkimlmvRZ9pg=";
          }
          {
            name = "copilot";
            publisher = "GitHub";
            version = "1.319.1560";
            sha256 = "DSh7gN0iMxPhYXn95o5YxsL/Awy7SKkulJ33hT3Eqfo=";
          }
          {
            name = "vscode-wakatime";
            publisher = "WakaTime";
            version = "25.0.4";
            sha256 = "sha256-J+H/PShsOGwt0AZExLApXLl86XQdZbE5cPS9v4gOXWc=";
          }
        ];
    })
  ];
}
