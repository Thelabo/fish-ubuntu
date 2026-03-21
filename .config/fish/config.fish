## Ubuntu-safe Fish shell config (portable)

## Set values
## Run fastfetch as welcome message (when available)
function fish_greeting
    if command -q fastfetch
        fastfetch
    end
end

# Format man pages with batcat (Ubuntu package name)
if command -q batcat
    set -x MANROFFOPT "-c"
    set -x MANPAGER "sh -c 'col -bx | batcat -l man -p'"
    alias bat='batcat'
end

## Environment setup
# Apply .profile: use this to put fish-compatible profile logic in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

# Activate mise when installed
if command -q mise
    mise activate fish | source
end

# SSH agent (systemd socket-activated)
if test -n "$XDG_RUNTIME_DIR"
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end

## Functions
# Functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history with timestamps
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2 (trim trailing slash from source dir)
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (string trim --right --chars=/ -- $argv[1])
        set to $argv[2]
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Aliases and plugin-specific settings live under conf.d/*.fish
