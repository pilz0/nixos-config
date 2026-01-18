if [[ "$1" == "apply-local" ]]; then
    colmena $1 --impure --sudo --nix-option "experimental-features" "pipe-operators flakes nix-command"
elif [[ "$1" == "mac" ]]; then
   sudo darwin-rebuild $2 --flake .
else
    colmena $1 --impure --nix-option "experimental-features" "pipe-operators flakes nix-command" --on $2
fi