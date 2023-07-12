{
  description = "Useful tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";

    #    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "openssl-1.1.1u" ];
      };

      nixdots = pkgs.stdenvNoCC.mkDerivation rec {
        name = "nixdots";
        src = ./.;

        nativeBuildInputs = with pkgs; [ ];

        buildInputs = import ./nix/packages.nix { inherit pkgs; };

        preBuild = "";

        buildPhase = "";

        installPhase = "";

        shellHook = ''
          . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"
          . "${pkgs.git}/share/bash-completion/completions/git"
          eval "$(zoxide init bash)"
        '';
      };

    in {
      defaultPackage.${system} = nixdots;
      homeConfigurations."niteria" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
