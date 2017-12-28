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
alias ghcm='make -j60; iterm_notify "GHC build done!"'
alias ghcv='./validate; iterm_notify "Validate done."'
alias st2='sed -i "s/^#stage=2/stage=2/" mk/build.mk'
alias st1='sed -i "s/^stage=2/#stage=2/" mk/build.mk'
alias ghcwspace='git submodule update --init && make clean && make distclean && cp ~/.templates/build.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwspaceprof='git submodule update --init && make clean && make distclean && cp ~/.templates/prof.build.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwspaceperf='git submodule update --init && make clean && make distclean && cp ~/.templates/perf.build.mk mk/build.mk && ./boot && ./configure && st1 && ghcm && st2; iterm_notify ghcwspace'
alias ghcwv='git submodule update --init && make clean && make distclean && cp ~/.templates/build.mk mk/build.mk && ./validate; iterm_notify ghcwvalidate'

alias shift_path='export PATH=$(echo $PATH | sed "s/^.[^:]*://")'
function add_path() {
  export PATH="$1:$PATH"
}
