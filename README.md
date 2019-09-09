```
git clone git@github.com:niteria/dotfiles.git
cd dotfiles
stow -t ~ nvim
stow -t ~ tmux
stow -t ~ bash
```

# Setup

## Neovim

### macOS

```
brew install stow
brew install neovim/neovim/neovim
pip2 install neovim
pip3 install neovim
sudo gem install neovim
# for swift
brew install swiftlint
```

### Ubuntu

```
sudo apt install stow
sudo apt install neovim

sudo apt install python-pip
pip2 install neovim

sudo apt install python3-pip
pip3 install neovim

sudo apt install ruby-dev
sudo gem install neovim
```

### In Neovim

```
:PlugInstall
```

### For Swift

https://github.com/keith/sourcekittendaemon.vim#installation -
Swift autocomplete


## Tmux

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

In Tmux:
`Ctrl-B I` to install plugins.
