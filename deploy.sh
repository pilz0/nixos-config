if [[ "$1" == "apply-local" ]]; then
    colmena $1 --impure --sudo --nix-option "experimental-features" "pipe-operator pipe-operators flakes nix-command" --verbose
elif [[ "$1" == "mac" ]]; then
    sudo env NIX_CONFIG=$'accept-flake-config = true\nexperimental-features = nix-command flakes pipe-operator pipe-operators' \
         darwin-rebuild $2 --flake . --impure
elif [[ "$1" == "fix-rosetta" ]]; then
    sudo launchctl bootout system/org.nixos.rosetta-builderd
    sleep 10
    sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.rosetta-builderd.plist
elif [[ "$1" == "exec" ]]; then
    on="$2"
    shift 2
    [[ "$1" == "--" ]] && shift
    colmena exec --impure --nix-option "experimental-features" "pipe-operators pipe-operator flakes nix-command" --on "*$on*" --verbose -- "$@"
else
    colmena $1 --impure --nix-option "experimental-features" "pipe-operators pipe-operator flakes nix-command" --on "*$2*" --verbose
fi
