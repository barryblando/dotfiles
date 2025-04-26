#!/usr/bin/env bash

set -euo pipefail

# --- CONFIG ---
GITHUB_REPO_URL="https://github.com/barryblando/dotfiles.git"
DOTFILES_DIR="${HOME}/.dotfiles"
APT_PACKAGES=("git")
BREW_PACKAGES=("neovim" "stow" "curl" "tmux" "fish" "starship" "lazygit" "zellij" "bat")
STOW_FOLDERS=("nvim" "tmux" "starship" "lazygit" "zellij")  # Specific folders to stow

# --- FUNCTIONS ---
check_internet() {
    echo "[+] Checking internet connectivity..."
    if ! ping -c 1 github.com &>/dev/null; then
        echo "[!] No internet connection or github.com unreachable."
        exit 1
    fi
}

install_linuxbrew() {
    if ! command -v brew &>/dev/null; then
        echo "[+] Installing Linuxbrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo '[ -f ~/.linuxbrew/setup.sh ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

install_packages_apt() {
    if command -v apt &>/dev/null; then
        echo "[+] Installing APT dependencies..."
        sudo apt update
        sudo apt install -y "${APT_PACKAGES[@]}"
    else
        echo "[!] Skipping apt install (not found)"
    fi
}

clone_dotfiles_repo() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "[+] Cloning dotfiles repo into $DOTFILES_DIR..."
        git clone "$GITHUB_REPO_URL" "$DOTFILES_DIR"
    else
        echo "[✓] Dotfiles already present at $DOTFILES_DIR"
    fi
}

install_packages_brew() {
    echo "[+] Installing Brew packages..."
    for pkg in "${BREW_PACKAGES[@]}"; do
        if ! brew list "$pkg" &>/dev/null; then
            brew install "$pkg"
        else
            echo "    [→] $pkg already installed via brew"
        fi
    done
}

set_fish_default_shell() {
    echo "[+] Setting Fish as default shell..."
    local fish_path
    fish_path="$(which fish)"

    if ! grep -q "$fish_path" /etc/shells; then
        echo "    [→] Adding $fish_path to /etc/shells"
        echo "$fish_path" | sudo tee -a /etc/shells
    fi

    chsh -s "$fish_path"
    echo "[✓] Fish is now your default shell (log out & back in if needed)"
}

stow_folder() {
    local folder="$1"
    local target="$HOME/.config/$folder"
    if [ -d "$target" ]; then
        echo "    [→] Removing existing $target"
        rm -rf "$target"
    fi
    echo "    [→] Stowing $folder"
    stow -d "$DOTFILES_DIR" -v "$folder"
}

# No need to call this function, saved for docs only
stow_dotfiles() {
    echo "[+] Stowing dotfiles from $DOTFILES_DIR..."

    # Check and remove existing config files in home
    for folder in "${STOW_FOLDERS[@]}"; do
        target_dir="$HOME/.config/$folder"
        
        if [ -d "$target_dir" ]; then
            echo "    [→] Removing existing $target_dir..."
            rm -rf "$target_dir"
        fi

        echo "    [→] Stowing $folder"
        stow -v "$folder"
    done
}

# Homebrew environment (hardcoded for Linuxbrew)
# Ensures that Homebrew is correctly initialized inside the Fish shell
# Just like you’d usually add eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" to .bashrc or .zshrc.
# No need to call this function, saved for docs only
configure_fish_brew_env() {
    local fish_config="$HOME/.config/fish/config.fish"
    if ! grep -q 'brew shellenv' "$fish_config" 2>/dev/null; then
        echo "[+] Adding brew shellenv to Fish config..."
        mkdir -p "$(dirname "$fish_config")"
        echo 'eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>"$fish_config"
    fi
}

# --- MAIN ---
check_internet
install_linuxbrew
install_packages_apt
install_packages_brew
clone_dotfiles_repo
# configure_fish_brew_env

# Stow fish early
echo "[+] Setting up Fish config first..."
stow_folder "fish"

# Set fish as the default shell
set_fish_default_shell

# Stow the rest
echo "[+] Stowing remaining dotfiles..."
for folder in "${STOW_FOLDERS[@]}"; do
    stow_folder "$folder"
done

echo "[✓] Dotfiles installation complete!"

