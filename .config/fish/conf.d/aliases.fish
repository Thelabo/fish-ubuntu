## Portable aliases (Ubuntu-focused)

# Prefer eza when available; otherwise provide plain ls fallbacks
if command -q eza
    alias ls='eza -al --color=always --group-directories-first --icons'
    alias la='eza -a --color=always --group-directories-first --icons'
    alias ll='eza -l --color=always --group-directories-first --icons'
    alias lt='eza -aT --color=always --group-directories-first --icons'
    alias l.="eza -a | grep -e '^\\.'"
else
    alias ls='ls --color=auto'
    alias la='ls -A'
    alias ll='ls -alF'
    alias lt='ls -al'
    alias l.="ls -A | grep -e '^\\.'"
end

alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if command -q hwinfo
    alias hw='hwinfo --short'
end

alias please='sudo'
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'
alias grubup='sudo update-grub'
alias tb='nc termbin.com 9999'
alias jctl='journalctl -p 3 -xb'
