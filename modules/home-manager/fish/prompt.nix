{ pkgs, ... }:

{
  programs.fish.functions = {
    fish_prompt = {
      # This file is modified from the default fish_prompt.fish file that comes with fish shell.
      # The default file is located at /usr/share/fish/functions/fish_prompt.fish
      # and is licensed under the GNU General Public License version 2 or later.
      # The default file is also available at https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_prompt.fish
      # We changed the prompt to add an extra newline before the `>` or `#` prompt.
      body = ''
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)
        set -q fish_color_status
        or set -g fish_color_status red

        # Color the prompt differently when we're root
        set -l color_cwd $fish_color_cwd
        set -l suffix '>'
        if functions -q fish_is_root_user; and fish_is_root_user
          if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
          end
          set suffix '#'
        end

        # Write pipestatus
        # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
        set -l bold_flag --bold
        set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        if test $__fish_prompt_status_generation = $status_generation
          set bold_flag
        end
        set __fish_prompt_status_generation $status_generation
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color $bold_flag $fish_color_status)
        set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        echo -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status
        echo -n -s $suffix " "
      '';
      description = "Custom fish prompt";
    };
  };

  prompt_login = {
    description = "display user name for the prompt";
    # FIXME: Is debian_chroot used in NixOS?
    body = ''
      if not set -q __fish_machine
        set -g __fish_machine
        set -l debian_chroot $debian_chroot

        if test -r /etc/debian_chroot
          set debian_chroot (cat /etc/debian_chroot)
        end

        if set -q debian_chroot[1]
          and test -n "$debian_chroot"
          set -g __fish_machine "(chroot:$debian_chroot)"
        end
      end

      # Prepend the chroot environment if present
      if set -q __fish_machine[1]
        echo -n -s (set_color yellow) "$__fish_machine" (set_color normal) ' '
      end

      # If we're running via SSH, change the host color.
      set -l color_host $fish_color_host
      if set -q SSH_TTY; and set -q fish_color_host_remote
        set color_host $fish_color_host_remote
      end

      echo -n -s (set_color $fish_color_user) "$USER" (set_color normal) (set_color normal)
    '';
  };
}
