export AUTO_TITLE_SCREENS="NO"

autoload -U promptinit && promptinit
prompt adam1

set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

# My aliases
alias cd-='cd -'
alias 'cd..'='cd ..'
alias cm='cvs -q commit'
alias cu='cvs -q update -dP'
alias vi='vim'
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias upppp='cd ../../../..'
alias uppppp='cd ../../../../..'
alias tdiff='git diff mainline "$(git branch --show-current)" --'
alias gitfiles='git diff-tree --no-commit-id --name-only -r'
