# Load environment variables and PATH
set -gx BUN_INSTALL "/home/bblando0x15/.bun"
set -gx PATH "$BUN_INSTALL/bin:$PATH"

set -gx DENO_INSTALL "/home/bblando0x15/.deno"
set -gx PATH "$DENO_INSTALL/bin:$PATH"

set -gx PATH "$HOME/.cargo/bin:$PATH"
set -gx PATH "$PATH:/home/bblando0x15/.local/bin"

# Additional PATH configurations
set -gx BREW_HOME "/home/linuxbrew/.linuxbrew/bin"
set -gx PATH "$PATH:$BREW_HOME"

# Neovide support
set -gx PATH "$PATH:/home/linuxbrew/.linuxbrew/bin/nvim"

# GOPATH for Go
set -gx GOPATH "$HOME/go"
set -gx GOROOT "$(brew --prefix golang)/libexec"
set -gx PATH "$PATH:$GOROOT/bin:$GOPATH/bin"


