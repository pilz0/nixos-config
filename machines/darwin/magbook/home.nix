{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../../modules/darwin/shell
  ];

  age.secrets.hydra-mcp-password = {
    file = ../../../secrets/hydra-mcp-password.age;
    # default secretsDir is a shell expression on darwin, hydra-mcp needs a literal path
    path = "${config.home.homeDirectory}/.secrets/hydra/password";
  };

  xdg.configFile."hydra-mcp/config.toml".text = ''
    default = "kyouma"

    [instances.kyouma]
    url = "https://hydra.kyouma.net"
    username = "pilz"
    password_file = "${config.age.secrets.hydra-mcp-password.path}"

    [instances.nixos]
    url = "https://hydra.nixos.org"
  '';

  programs.claude-code = {
    enable = true;
    # claude-code itself comes from modules/darwin/pkgs
    package = null;
    mutableSettings = true;
    mcpServers.hydra = {
      command = "${pkgs.callPackage ../../../pkgs/hydra-mcp.nix { inherit inputs; }}/bin/hydra-mcp";
    };
  };

  home.stateVersion = "25.11";
}
