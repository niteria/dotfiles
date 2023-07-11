{
  description = "Useful tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";

    #    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [ "openssl-1.1.1u" ];
        };

        add-completions = pkgs.writeScriptBin "add-completions" ''
          . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
          . "${pkgs.git}/share/bash-completion/completions/git"
        '';

        nixdots = pkgs.stdenvNoCC.mkDerivation rec {
          name = "nixdots";
          src = ./.;

          nativeBuildInputs = with pkgs; [ ];

          x86-info-term = pkgs.callPackage ./tools/x86-info-term.nix { };

          buildInputs = with pkgs; [
            add-completions
            arcanist
            atop
            bintools
            btop
            htop
            glances
            difftastic
            ethtool
            fastmod
            fd
            fzf
            gitui
            hexyl
            htop
            nodePackages.js-beautify
            lazygit
            lsd
            # will be renamed to lua-language-server
            sumneko-lua-language-server
            mcfly
            neovim
            nix-prefetch-github
            nixfmt
            nodejs
            #            perf-linux
            php
            pstree
            pciutils
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
          ];

          preBuild = "";

          buildPhase = "";

          installPhase = "";

          shellHook = ''
            . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
            . "${pkgs.git}/share/bash-completion/completions/git"
            eval "$(zoxide init bash)"
          '';
        };

        flake = { defaultPackage = nixdots; };

      in flake);
}
