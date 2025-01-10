{ ... }:
{
  programs.zsh.shellAliases = {
    update = "sudo nix flake update /home/marie/nixos-config";
    rebuild = "sudo nixos-rebuild --flake /home/marie/nixos-config";
  };
}
