if [[ "$1" == "mac" ]]; then
    sudo env NIX_CONFIG=$'accept-flake-config = true\nexperimental-features = nix-command flakes\nextra-experimental-features = pipe-operators' \
         darwin-rebuild $2 --flake . --impure --verbose
elif [[ "$1" == "exec" ]] && [[ "$2" == *"@"* ]]; then
    on="$2"
    shift 2
    [[ "$1" == "--" ]] && shift
    colmena exec --impure --on $on --verbose -- "$@"
elif [[ "$1" == "exec" ]]; then
    on="$2"
    shift 2
    [[ "$1" == "--" ]] && shift
    colmena exec --impure --on "*$on*" --verbose -- "$@"
elif [[ "$2" == *"@"* ]]; then
    colmena $1 --impure--on $2 --verbose
else
    colmena $1 --impure --on "*$2*" --verbose
fi
