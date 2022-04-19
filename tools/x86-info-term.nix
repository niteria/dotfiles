{ pkgs }:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "x86-info-term";
  version = "97ce70a66516c158043e150750f0c90dc582784e";
  src = pkgs.fetchFromGitHub {
    owner = "zwegner";
    repo = name;
    rev = "${version}";
    sha256 = "gngFcQI0A3A72rzlWlJIZc0oLFzoyKKvY9PdMSfpAS4=";
  };

  buildPhase = "";

  installPhase = ''
    mkdir -p "$out"/bin;
    echo "${pkgs.python3}/bin/python3" "${src}/x86_info_term.py" -p \$HOME/.cache/x86_info_term/ \"\$@\"> "$out"/bin/$name
    chmod +x "$out"/bin/$name
  '';

}
