#! /usr/bin/env nix-shell
#! nix-shell -i fish -p fish

cd "$(dirname "$0")"

function show_help
    echo "Usage: switch.fish [options] [host]"
    echo ""
    echo "Switch to a new configuration for the specified host (Default to current hostname)."
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  --mirror         Use mirror substituters for China users"
    echo "  --vm             Use nixos-rebuild test (dry-run)"
    echo "  --boot           Use `nixos-reboot` instead of `nixos-rebuild switch`"
    echo ""
    echo "Examples:"
    echo "  ./switch.fish"
end

set cmd "nixos-rebuild switch"
set dry_run false
set host (uname -n)
set host_set false
set rest

for arg in $argv
    switch $arg
        case '-h' '--help'
            show_help
            exit 0
        case '--mirror'
            set cmd "$cmd --option substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store https://nix-community.cachix.org https://cache.nixos.org'"
        case '--dry'
            set dry_run true
        case '--boot'
            set cmd "nixos-rebuild boot"
        case '*'
            if test $host_set = false; and not string match -q -- '-*' $arg; and string match -q -r -- '^[a-zA-Z0-9_-]+$' $arg
                set host $arg
                set host_set true
            else
                set rest $rest $arg
            end
    end
end

if test $dry_run = true
    set cmd "nixos-rebuild test"
end

if test (id -u) -ne 0
    set cmd "sudo $cmd"
end

set cmd "$cmd --flake '.#$host' $rest"

echo "Running: $cmd"
eval $cmd
