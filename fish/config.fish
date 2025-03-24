# Set some Environment Variables
set -x EDITOR nvim
# alias config "cd ~/.config"
# alias dotfiles "/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME/.config"

fish_add_path /home/benjamin/.config/scripts/
fish_add_path /home/benjamin/.ghcup/bin/
fish_add_path /home/benjamin/.cargo/bin
set -U fish_greeting



# ENVIRONMENT VARIABLES
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

export LD_LIBRARY_PATH=/usr/local/lib
export GI_TYPELIB_PATH=/usr/lib/girepository-1.0


if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_color_host_remote red

function fish_prompt -d "Write out the prompt"
	# This shows up as USER@HOST /home/user/ >, with the directory colored
	# $USER and $hostname are set by fish, so you can just use them
	# instead of using `whoami` and `hostname`
    set ssh_indicator (test -n "$SSH_CLIENT" -o -n "$SSH_TTY"; and echo "[SSH|$hostname] "; or echo "")
    printf '%s%s%s%s%s%s >%s%s%s ' (set_color -o red) $ssh_indicator (set_color normal) $USER \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)\
        (set_color red -o) (fish_git_prompt) (set_color normal)
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	kitty-full yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

bind -M "insert" \cf forward-char
bind -M "insert" \ce forward-word

bind -M "insert" \ck history-search-backward
bind -M "insert" \cj history-search-forward

bind -M "insert" \ef tmuxer


function tmuxer
    tmux-sessionizer
    commandline -f repaint
end

# Check if a file path is provided as an argument
function opdf_func
    if test (count $argv) -eq 1
        # If a file path is provided, open it in Zathura
        nohup zathura $argv[1] >/dev/null 2>&1 & disown
    else
        # If no file path is provided, use fzf to search for a file in the current directory
        set selected_file (find . -type f -name "*.pdf" | fzf)
        if test -n "$selected_file"
            # If a file is selected, open it in Zathura
            nohup zathura $selected_file >/dev/null 2>&1 & disown
        else
            echo "No file selected. Exiting."
        end
    end
end

zoxide init fish | source
alias cd "z"
alias todo "nvim ~/.todo.md"
alias vim "$HOME/.config/scripts/kitty-full nvim"
alias nvim "$HOME/.config/scripts/kitty-full nvim"
alias sus "systemctl suspend; hyprlock --imediate"
alias ghci "ghci-color"
alias opdf "opdf_func"
alias rekey "systemctl --user restart kanata.service"
alias REKEY "systemctl --user restart kanata.service"
alias w3m "kitty-full w3m"
alias cdf "cd \"\$(fd . -t d | fzf)\""
alias mossy "sshfs moss: Moss/ -o ServerAliveInterval=15"
alias shitter "cat ~/.AUR/Limoji/unicode | rofi -dmenu -i | cut -d'=' -f1 | xargs ~/.AUR/Limoji/limoji"
alias saveshit "wl-paste | rofi -dmenu -i -p \"Name of this critter?\" | xargs -I {} echo {}=\"\$(wl-paste | ~/.config/scripts/destring)\" >>~/.AUR/Limoji/unicode"
alias ls "ls --color -h --group-directories-first"
alias pop "slurp | grim -g - /tmp/screenshot.png && imv /tmp/screenshot.png"

# Created by `pipx` on 2024-08-05 14:43:29
set PATH $PATH /home/benjamin/.local/bin
# Add pyenv executable to PATH by running
# the following interactively:
# fish_config theme save "Catppuccin Macchiato"

source "$HOME/.cargo/env.fish"
