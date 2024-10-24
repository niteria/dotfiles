{ pkgs }:
let
  x86-info-term = pkgs.callPackage ../tools/x86-info-term.nix { };

  add-completions = pkgs.writeScriptBin "add-completions" ''
    . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
    . "${pkgs.git}/share/bash-completion/completions/git"
  '';

in with pkgs; [
  add-completions
  arcanist
  atop
  bintools
  btop
  htop
  glances
  difftastic
  # open diff in the browser with diff2html -s side
  nodePackages.diff2html-cli
  ethtool
  fastmod
  fd
  fzf
  gcc_latest
  gitui
  hexyl
  htop
  nodePackages.js-beautify
  lazygit
  lsd
  # will be renamed to lua-language-server
  sumneko-lua-language-server
  manix
  mcfly
  mosh
  neovim
  nix-prefetch-github
  nixfmt
  nodejs
  #            perf-linux
  php
  pstree
  pciutils
  # autoreloading markdown renderer
  python311Packages.grip
  ripgrep
  rnix-lsp
  stow
  stylua
  sysz
  tmux
  unzip
  wget
  x86-info-term
  yarn
  zoxide
]
