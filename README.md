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
