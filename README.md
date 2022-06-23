<h1 align="center">~/.dotfiles</h1>

<p align="center"><sub>~~ Little things that you can't live without ~~</sub></p>

### ⚠️ Requirements

#### Commands

- sudo (maybe)
- git
- bash
- make
- unzip
- GNU tar
- [GNU stow](https://github.com/aspiers/stow)
- gcc or clang (for compiling neovim treesitter parsers)

#### Fonts

These dotfiles doesn't contains any font installation so you have install them beforehand.

- [MonoLisa](https://www.monolisa.dev/) - for main font
- [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) - as fallback font for Icons and Glyphs

### 🚀 Installation

- Clone the repository into `$HOME/.dotfiles` and `cd` into it.

```
git clone https://github.com/barryblando/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

- Make sure you clean/remove all files that need to be symlink in `.dotfiles` folder before running `stow`

### 🖥️ Software

- OS: Debian (Linux) under WSL2
- Distro: Pengwin (WLinux)
- Desktop: Windows 11
- Terminal: [WezTerm](https://wezfurlong.org/wezterm/install/linux.html)

### 🙏 Credits

- numToStr's [dotfiles setup](https://github.com/numToStr/dotfiles)
- System Crafters for this [guide](https://www.youtube.com/watch?v=CxAT1u8G7is)
