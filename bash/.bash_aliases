alias join_comma="tr '\n' ',' | sed 's/,$/\n/'"
alias join_space="tr '\n' ' ' | sed 's/,$/\n/'"
alias escape='sed '\''s/\\/\\\\/g'\'' | sed '\''s/\"/\\\"/g'\'''
alias trim="sed 's/^ *//' | sed 's/ *$//'"
alias join_nothing='perl -pe "s/\n$//"'
alias gitwipe='git reset HEAD && git checkout -- . && git clean -dff'
alias gdc='git diff --cached'
alias gd='git diff'
alias gcam='git commit --amend'
alias gs='git status'
alias gam='git add -u && git commit --amend --no-edit'
alias gn='git show --name-only'
alias gitbd='git diff $(git merge-base --fork-point master)'

alias hgwipe='hg revert --all && hg purge'
alias ham='hg amend'

alias vim="nvim -p"
alias vimdiff="nvim -d"
alias gdb_dump_stacks='gdb -ex "set pagination 0" -ex "thread apply all bt" --batch -p'

alias ghc-sandbox="ghc -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias ghci-sandbox="ghci -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias runhaskell-sandbox="runhaskell -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"

function tmux_detach_all() {
  for sess in `tmux ls | grep attached | sed -e 's/:.*//g'`; do tmux detach -s "$sess"; done
}

function iterm_notify() {
  echo && echo -en iTerm""Notify "$@\r" && sleep 1 && echo "     "
}

# git grep, you don't need quotes around the text
# $ gg Replace hooks by callbacks in RtsConfig
function gg() { 
  ARGZ="$*"
  git log --grep="$ARGZ" 
}

alias ghcclean-stage2='rm -rf compiler/stage2; rm -rf libraries/*/dist-install'
# via _NPROCESSORS_ONLN
NUM_CORES=$(getconf _NPROCESSORS_ONLN)
alias ghcm='make -j'$NUM_CORES'; iterm_notify "GHC build done!"'
alias ghcv='./validate; iterm_notify "Validate done."'
alias st2='sed -i "s/^#stage=2/stage=2/" mk/build.mk'
alias st1='sed -i "s/^stage=2/#stage=2/" mk/build.mk'
alias ghcwspace='git submodule update --init && make clean && make distclean && cp ~/.templates/build.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwspaceg='git submodule update --init && make clean && make distclean && cp ~/.templates/devel2-dwarf.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwspaceprof='git submodule update --init && make clean && make distclean && cp ~/.templates/prof.build.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwspaceperf='git submodule update --init && make clean && make distclean && cp ~/.templates/perf.build.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwv='git submodule update --init && make clean && make distclean && cp ~/.templates/build.mk mk/build.mk && ./validate; iterm_notify ghcwvalidate'

alias shift_path='export PATH=$(echo $PATH | sed "s/^.[^:]*://")'
function add_path() {
  export PATH="$1:$PATH"
}

function vimf() {
  vim $(fzf -m -q "$*");
}
# Home Manager Update
alias hmu="nix run home-manager/release-23.05 -- switch --flake ~/dotfiles/.#niteria"

# rocinante stuff

function rconnect() {
  CLIENT="$1"
  HOST="$2"
  [ -z "$TMUX" ] && "$CLIENT" "$HOST"
  [ -n "$TMUX" ] && tmux detach-client -E "$CLIENT $HOST"
}

function tconnect() {
  CLIENT="$1"
  HOST="$(tailscale ip --4 $2)"
  rconnect "$CLIENT" "$HOST"
}


function srailgun() {
  rconnect ssh railgun
}

function mrailgun() {
  rconnect mosh railgun
}

function mmedina() {
  rconnect mosh medina
}

function mtailgun() {
  tconnect mosh railgun
}

function mwatchtower() {
  tconnect mosh watchtower
}

function mgochujang() {
  tconnect mosh gochujang
}

function sgochujang() {
  rconnect ssh gochujang
}
