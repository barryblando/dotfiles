<h1 align="center">~/.dotfiles</h1>

<p align="center"><sub>~~ Little things that you can't live without ~~</sub></p>

### ⚠️ Requirements

#### Commands

- sudo (maybe)
- git
- bash
- make
- unzip
- mklink (sym-linking for windows)
- GNU tar
- [GNU stow](https://github.com/aspiers/stow)
- gcc or clang (for compiling neovim treesitter parsers)

#### Fonts

These dotfiles doesn't contains any font installation so you have install them beforehand.

- [MonoLisa](https://www.monolisa.dev/) - for main font
- [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) - as fallback font

### 🚀 Installation

- Clone the repository into `$HOME/.dotfiles` and `cd` into it.

```
git clone https://github.com/barryblando/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
```

- Make sure you clean/remove all files that needed to be symlink from `.dotfiles` folder

### 🔗 Linking

* Linux

```shell
stow {directory name} i.e neovim folder
```
  ** **NOTICE** we didn't specify what the target directory is! By default, `stow` assumes that the target directory is the parent directory of the one you specified:  `stow -d ~/.dotfiles -t ~/`
     
- Windows (Admin-Level Command Prompt)

```
mklink /D c:\Users\{username}\.config\wezterm\ c:\Users\{username}\.dotfiles\wezterm\.config\wezterm\
```

### 🖥️ Software

- OS: Debian (Linux) under WSL2
- Distro: Pengwin (WLinux)
- Desktop: Windows 11
- Terminal: [WezTerm](https://wezfurlong.org/wezterm/install/linux.html)

### 🙏 Credits

- numToStr's [dotfiles setup](https://github.com/numToStr/dotfiles)
- System Crafters for this [guide](https://www.youtube.com/watch?v=CxAT1u8G7is)
