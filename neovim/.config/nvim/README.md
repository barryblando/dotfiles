# WSL2 NEOVIM CONFIG

![screenshot](https://user-images.githubusercontent.com/5582213/174443676-7c273753-c1de-4731-bef8-bd3c1aaf590d.png)

[Follow this Playlist from Christian Chiarulli for Guides](https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ).

## Before setting this up... **FORK AT YOUR OWN RISK**

- I use this setup mainly on my Pengwin distro under WSL2.

  **Make sure you really know basics of Vim & Neovim.** You can join [@Machine Discord Server](https://discord.gg/6DRHpSRe)

- All plugins are up-to-date.

## Without further ado Lezzgaw!

- Install [Neovim v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0) or [Nightly](https://github.com/neovim/neovim/releases/tag/nightly). Using `linuxbrew`

```
brew install neovim
```

- Remove current `~/.config/nvim` directory
 
- If you have packers.nvim installed, remove `.local\share\nvim\site\pack`
 
- Clone
 
```
git clone https://github.com/barryblando/neovim-config-setup.git ~/.config/nvim
```

- Run `nvim` and wait for the plugins to be installed 

**NOTE** (You will notice treesitter pulling in a bunch of parsers the next time you open Neovim) 

- Install the following language servers:

```
npm i -g 
  bash-language-server
  dockerfile-language-server-nodejs
  diagnostic-languageserver
  @tailwindcss/language-server
  yaml-language-server
  vscode-langservers-extracted
  typescript typescript-language-server
  graphql-language-service-cli
  @prisma/language-server
  @ansible/ansible-language-server
  emmet-ls
  prettier

cargo install --locked taplo-cli
cargo install stylua

brew install hashicorp/tap/terraform-ls
brew install lua-language-server
brew install bufbuild/buf/buf
brew install hadolint

https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
```

- Install the following, in order for Telescope to work:

  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [fd](https://github.com/sharkdp/fd)

## Check NVIM health status

- Open `nvim` and enter the following:

```
:checkhealth

-- If you found errors just follow the instructions there i.e installing lazygit, lazydocker, lazynpm, ncdu, htop for Toggleterm
```

**IF ALL IS WELL. YOU'RE GOOD TO GO. GOOD LUCK, COMRADE!**

## Sources

- [Neovim LSP Doc](https://neovim.io/doc/user/lsp.html)
- [Neovim Diagnostic Doc](https://neovim.io/doc/user/diagnostic.html)
- [LSP Configuration List](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Terraform LS Installation](https://github.com/hashicorp/terraform-ls/blob/main/docs/installation.md)
- [Null-LS BUILTIN](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md)
- [Null-LS BUILTIN_CONFIG](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md)
