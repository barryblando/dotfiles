# show only once per login
set -g fish_greeting
if status is-login
    and status is-interactive
    if type -q neofetch
        neofetch
    end
end

# Load environment variables and PATH
set -gx PATH /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin $PATH

# Load other env vars
source ~/.config/fish/functions/env.fish

# Git Aliases
source ~/.config/fish/functions/git.fish

# NPM Aliases
source ~/.config/fish/functions/npm.fish

# Docker Aliases
source ~/.config/fish/functions/docker.fish

# Kubernetes Aliases
source ~/.config/fish/functions/kubernetes.fish

# Exa/Eza
source ~/.config/fish/functions/eza.fish

# Tmux and Zellij
source ~/.config/fish/functions/tmux.fish
source ~/.config/fish/functions/zellij.fish

# Misc
source ~/.config/fish/functions/misc.fish

# Starship (optional)
starship init fish | source

# Bun completions
# if test -e ~/.bun/_bun
#    source ~/.bun/_bun
# end

# Zellij/Pane Renaming (Fish style)
function update_tab_name --on-variable PWD
    if set -q ZELLIJ
        set tab_name (basename (git rev-parse --show-toplevel ^/dev/null 2>/dev/null) 2>/dev/null)
        if test -z "$tab_name"
            set tab_name (basename $PWD)
        end
        zellij action rename-tab $tab_name > /dev/null 2>&1
    end
    if set -q TMUX
        set tab_name (basename (git rev-parse --show-toplevel ^/dev/null 2>/dev/null) 2>/dev/null)
        if test -z "$tab_name"
            set tab_name (basename $PWD)
        end
        tmux rename-window $tab_name > /dev/null 2>&1
    end
end

update_tab_name
