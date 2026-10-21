#! /usr/bin/env fish

cd (dirname (status filename))

function show_help
    echo "Usage: switch.fish [options] [host]"
    echo ""
    echo "Switch to a new configuration for the specified host (Default to current hostname)."
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  --home, --home-manager  Use home-manager switch instead of nixos-rebuild switch"
    echo "  --mirror         Use mirror substituters for China users"
    echo "  --dry, --vm      Use nixos-rebuild test (dry-run); with --home, build instead of switch"
    echo "  --boot           Use nixos-rebuild boot instead of nixos-rebuild switch"
    echo ""
    echo "Examples:"
    echo "  ./switch.fish"
    echo "  ./switch.fish --home"
    echo "  ./switch.fish --home maiko@company"
end

# 用数组而非字符串拼接，避免 eval 导致参数边界丢失。
set mode system
set dry_run false
set boot_mode false
set mirror false
set host (uname -n)
set host_set false
set cmd_args

for arg in $argv
    switch $arg
        case '-h' '--help'
            show_help
            exit 0
        case '--mirror'
            set mirror true
        case '--dry' '--vm'
            set dry_run true
        case '--boot'
            set boot_mode true
        case '--home' '--home-manager'
            set mode home
        case '*'
            # 非选项且符合 host 命名的参数视为目标 host；其余原样透传。
            if test $host_set = false; and not string match -q -- '-*' $arg; and string match -q -r -- '^[a-zA-Z0-9@_.-]+$' $arg
                set host $arg
                set host_set true
            else
                set -a cmd_args $arg
            end
    end
end

# Home-manager flake configs are keyed by user@hostname
# (e.g. maiko@company, maiko@nixos). 仅当未显式指定 host 时默认 user@hostname。
if test $mode = home; and test $host_set = false
    set host (id -un)@(uname -n)
end

set flake_arg --flake ".#$host"

if test $mirror = true
    echo "Using mirror substituters..."
    set -a cmd_args --option substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store https://nix-community.cachix.org https://cache.nixos.org'
end

if test $mode = home
    # standalone home-manager 以当前用户身份运行，不应加 sudo。
    if test $dry_run = true
        set base home-manager build
    else
        set base home-manager switch
    end
    echo "Running: $base $flake_arg $cmd_args"
    $base $flake_arg $cmd_args
else
    set base nixos-rebuild switch
    if test $dry_run = true
        set base nixos-rebuild test
    else if test $boot_mode = true
        set base nixos-rebuild boot
    end
    if test (id -u) -ne 0
        echo "Running: sudo $base $flake_arg $cmd_args"
        sudo $base $flake_arg $cmd_args
    else
        echo "Running: $base $flake_arg $cmd_args"
        $base $flake_arg $cmd_args
    end
end
