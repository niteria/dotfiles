{ pkgs }:
let
  x86-info-term = pkgs.callPackage ../tools/x86-info-term.nix { };

  add-completions = pkgs.writeScriptBin "add-completions" ''
    . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
    . "${pkgs.git}/share/bash-completion/completions/git"
  '';

in
with pkgs;
[
  add-completions
  #  arcanist  # removed from nixpkgs
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
  jq
  nodePackages.js-beautify
  lazygit
  lsd
  lsof
  # will be renamed to lua-language-server
  sumneko-lua-language-server
  manix
  mcfly
  mosh
  neovim
  nil
  nix-prefetch-github
  nixfmt-rfc-style
  nodejs
  #            perf-linux
  php
  pstree
  pciutils
  # autoreloading markdown renderer
  python311Packages.grip
  ripgrep
  # rnix-lsp -> nil
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
