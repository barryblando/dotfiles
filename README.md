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
- [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) - as fallback font

### 🚀 Installation

- Clone the repository into `$HOME/.dotfiles` and `cd` into it.

```
git clone https://github.com/barryblando/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
```

- Make sure you clean/remove all files that needed to be symlink from `.dotfiles` folder

### 🔗 Linking

- **Linux**
  - **NOTICE** I didn't specify what the target directory is! By default, `stow` assumes that the target directory is the parent directory of the one you specified:  `stow -d ~/.dotfiles -t ~/`
   ```shell
    stow {folder name in .dotfiles} i.e neovim
    output: None
   ```

- **Windows**
  - For windows you can use stow via MSYS2. To install via MSYS2: `pacman -S stow`
  - To symlink correctly via MSYS2 uncomment line with: `MSYS=winsymlinks:nativestrict` in ini/config file. 
   - Location: `(C:\msys64 by default)`.
  - Now run MSYS2 with admin privileges and set target dir for `stow`:

  ```shell
   stow --target=/c/Users/Retr0_0x315/ wezterm
   output: None
  ```
  - I have to set target 'cause stow will put link under user directory not in .config folder
### 🖥️ Software

- OS: Debian (Linux) under WSL2
- Distro: Pengwin (WLinux)
- Desktop: Windows 11
- Terminal: [WezTerm](https://wezfurlong.org/wezterm/install/linux.html)

### 🙏 Credits

- numToStr's [dotfiles setup](https://github.com/numToStr/dotfiles)
- System Crafters for this [guide](https://www.youtube.com/watch?v=CxAT1u8G7is)
