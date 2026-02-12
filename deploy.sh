if [[ "$1" == "apply-local" ]]; then
    colmena $1 --impure --sudo --nix-option "experimental-features" "pipe-operators flakes nix-command --verbose"
elif [[ "$1" == "mac" ]]; then
   sudo darwin-rebuild $2 --flake . --impure --verbose
elif [[ "$1" == "fix-rosetta" ]]; then
    sudo launchctl bootout system/org.nixos.rosetta-builderd
    sleep 10
    sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.rosetta-builderd.plist
else
    colmena $1 --impure --nix-option "experimental-features" "pipe-operators flakes nix-command" --on "*$2*" --verbose
fi
