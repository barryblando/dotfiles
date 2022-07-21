# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
zstyle ':omz:update' mode reminder

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# BUN RUNTIME
BUN_INSTALL="/home/bblando0x15/.bun"
PATH="$BUN_INSTALL/bin:$PATH"

export DENO_INSTALL="/home/bblando0x15/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Created by `pipx` on 2022-06-21 13:33:23
export PATH="$PATH:/home/bblando0x15/.local/bin"

# Git Aliases
alias gc="git checkout";
alias gcm="git checkout master";
alias gs="git status";
alias gpull="git pull";
alias gf="git fetch";
alias gfa="git fetch --all";
alias gf="git fetch origin";
alias gpush="git push";
alias gpushf="git push -f";
alias gd="git diff";
alias ga="git add .";
alias glog="git log";
alias gb="git branch";
alias gbr="git branch remote"
alias gfr="git remote update"
alias gbn="git checkout -B "
alias grf="git reflog";
alias grh="git reset HEAD~" # last commit
alias gac="git add . && git commit -a -m "
alias gsu="git gpush --set-upstream origin "
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

# NPM Aliases
alias ni="npm install";
alias nrs="npm run start -s --";
alias nrb="npm run build -s --";
alias nrd="npm run dev -s --";
alias nrt="npm run test -s --";
alias nrtw="npm run test:watch -s --";
alias nrv="npm run validate -s --";
alias rnm="rm -rf node_modules";
alias npxctt="npx create-react-app --template typescript";
alias npxc="npx create-react-app";

# Kubernetes Aliases
alias k="kubecolor"

# Docker Aliases
alias dc="docker container "
alias di="docker image "
alias dv="docker volume "
alias dn="docker network "
alias dps="docker ps"
alias dcstop='docker-compose stop';
alias dcrst='docker-compose restart';
alias dcup='docker-compose up -d';
alias dcrm='docker-compose rm --all';

# Exa Aliases
if [ -x "$(command -v exa)" ]; then
  alias ls="exa --icons"
  alias la="exa --icons --long --all --group"
fi

# Tmux Aliases
alias tns="tmux new-session"
alias tnw="tmux new-window"
alias ta="tmux a" # attach to current running session

# Other Aliases
alias zshrc="vi ~/.zshrc"
alias zshhistory="vi ~/.zsh_history"
alias md="mkdir"
alias ..="cd .."
alias ...="cd ../.."
alias sourceslist="sudo vi /etc/apt/sources.list"
alias ovim="vim"
alias vim="nvim"
alias pip="pip3"
alias python="python3"

# Set up the prompt
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  taskwarrior
  httpie
  vscode
)

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# if you use manual installation
# source ~/powerlevel10k/powerlevel10k.zsh-theme 
# if you use oh-my-zsh https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

eval "$(fnm env --use-on-cd)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
