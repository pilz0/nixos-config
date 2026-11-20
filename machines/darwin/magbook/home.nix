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

  age.secrets.freellmapi-api-key = {
    file = ../../../secrets/freellmapi-api-key.age;
    path = "${config.home.homeDirectory}/.secrets/freellmapi/api-key";
  };

  # ECC hooks are `node -e ...` one-liners
  home.packages = [ pkgs.nodejs ];

  programs.claude-code = {
    enable = true;
    # claude-code itself comes from modules/darwin/pkgs
    package = null;
    mutableSettings = true;
    marketplaces.ecc = inputs.ecc;
    settings.enabledPlugins."ecc@ecc" = true;
    mcpServers = {
      hydra = {
        command = "${pkgs.callPackage ../../../pkgs/hydra-mcp.nix { inherit inputs; }}/bin/hydra-mcp";
      };
      freellmapi-search = {
        command = "${
          pkgs.writers.writePython3Bin "freellmapi-search-mcp" { flakeIgnore = [ "E501" ]; } (
            builtins.readFile ../../../pkgs/freellmapi-search-mcp/freellmapi-search-mcp.py
          )
        }/bin/freellmapi-search-mcp";
        env = {
          FREELLMAPI_BASE_URL = "https://freellmapi.freifick.net";
          FREELLMAPI_API_KEY_FILE = config.age.secrets.freellmapi-api-key.path;
        };
      };
    };
  };

  home.stateVersion = "25.11";
}
