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
    echo "  --mirror         Use Tsinghua University TUNA substituters"
    echo "  --vm             Use nixos-rebuild test (dry-run)"
    echo ""
    echo "Examples:"
    echo "  ./switch.fish"
end

set cmd "nixos-rebuild switch"
set dry_run false
set host (uname -n)

for arg in $argv
    switch $arg
        case '-h' '--help'
            show_help
            exit 0
        case '--mirror'
            set cmd "$cmd --option substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store'"
        case '--vm'
            set dry_run true
        case '*'
            # if $arg is not start with '--', it should be the host name
            if string match -q -- '--*' $arg
                echo "Unknown option: $arg"
                show_help
                exit 1
            end
            set host $arg
    end
end

if test $dry_run = true
    set cmd "nixos-rebuild test"
end

if test (id -u) -ne 0
    set cmd "sudo $cmd"
end

set cmd "$cmd --flake '.#$host'"

echo "Running: $cmd"
eval $cmd
