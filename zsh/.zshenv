BUN_INSTALL="/home/bblando0x15/.bun"
PATH="$BUN_INSTALL/bin:$PATH"

DENO_INSTALL="/home/bblando0x15/.deno"
PATH="$DENO_INSTALL/bin:$PATH"

PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
PATH="$PATH:$BREW_HOME"

PATH="$HOME/.cargo/bin:$PATH"

PATH="$PATH:/home/bblando0x15/.local/bin"

# sourcing nvim path in order for neovide command to work (neovide --wsl)
PATH="$PATH:/home/linuxbrew/.linuxbrew/bin/nvim"

# TERMINFO="/home/bblando0x15/.terminfo/"

# GOPATH="/usr/local/go"
# PATH="$PATH:$GOPATH/bin"
export GOROOT="$(brew --prefix golang)/libexec"
