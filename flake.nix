{
  description = "Useful tools";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/21.11";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        add-completions = pkgs.writeScriptBin "add-completions" ''
          . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
          . "${pkgs.git}/share/bash-completion/completions/git"
        '';

        nixdots = pkgs.stdenvNoCC.mkDerivation rec {
          name = "nixdots";
          src = ./.;

          nativeBuildInputs = with pkgs; [ ];

          buildInputs = with pkgs; [
            add-completions
            atop
            difftastic
            fzf
            htop
            mcfly
            neovim
            nix-prefetch-github
            nixfmt
            nodejs
            #            perf-linux
            php
            pstree
            ripgrep
            stow
            tmux
            unzip
            wget
            yarn
          ];

          preBuild = "";

          buildPhase = "";

          installPhase = "";

          shellHook = ''
            . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
            . "${pkgs.git}/share/bash-completion/completions/git"
            eval "$(mcfly init bash)"
          '';
        };

        flake = { defaultPackage = nixdots; };

      in flake);
}
