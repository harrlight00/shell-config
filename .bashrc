if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export EDITOR="vim"
export CVSROOT="/var/lib/cvs"
export CVSEDITOR="vim"
export CVS_RSH="ssh"
export SVKROOT="/var/lib/svk"
export SVN_EDITOR="vim"
git_branch() {
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? == 0 ]; then
        cut -b 17-37 < ${GIT_DIR}/HEAD
    fi
}
# Alternatively: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
PS1='\[\e]0;\u@\h:\w\007\][$(date +%H:%M)]-[\u@\h: \[\e[0;32m\]\w\[\e[0m\]\[\e[0;36m\] ${GIT_BRANCH}\[\e[0;00m\]]\$ '
PROMPT_COMMAND=$'GIT_BRANCH=$(git_branch)'
PATH="$HOME/dev/utils:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11"
export PATH PS1 PROMPT_COMMAND

# use man to get perldocs for Lots::Of::GSG::Modules
export MANPATH=/usr/local/gsgperl/gsg-epay/active/man:/usr/local/share/man:/usr/share/man/en:/usr/share/man

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#===============================================================================
# Font generated at
# http://patorjk.com/software/taag/#p=display&f=Standard&t=History%20Control%0A
#  _   _ _     _                      ____            _             _ 
# | | | (_)___| |_ ___  _ __ _   _   / ___|___  _ __ | |_ _ __ ___ | |
# | |_| | / __| __/ _ \| '__| | | | | |   / _ \| '_ \| __| '__/ _ \| |
# |  _  | \__ \ || (_) | |  | |_| | | |__| (_) | | | | |_| | | (_) | |
# |_| |_|_|___/\__\___/|_|   \__, |  \____\___/|_| |_|\__|_|  \___/|_|
#                            |___/                                    
# These settings are designed to save 30,000 unique lines.
# This works across multiple SSH sessions by using 'history -a' to append the
# history file on every command.
#
# There is a duplicate line awk script to keep the history unique and save on
# history space. It uses 'tac' to remove everything but the last dupe,
# so that you aren't searching very far for a recent command that happened to be# a dupe.  It's also a good idea to put this script into your ~/.bash_logout.
#
# Your preferences may vary.  Change as necessary.
#===============================================================================
# Remove duplicate lines in bash history file
if [[ -r ~/.bash_history && -w ~/.bash_history && -O ~/.bash_history && -G ~/.bash_history ]]; then
    (tac ~/.bash_history | awk '!x[$0]++ && !/^\#/' | tac) > ~/.bash_history_new && mv ~/.bash_history_new ~/.bash_history
fi 
# various history options (which updates on every command)
export HISTCONTROL=ignoredups
export HISTIGNORE="ls:dir:exit:cd:cd ..:cd -:cd ~:perl"
#export HISTTIMEFORMAT="%F %T: " # buggy with removedups
export PROMPT_COMMAND="history -a"
shopt -s histappend

#===============================================================================
#  _____                         ____      _                    _ 
# |  ___|_ _ _ __   ___ _   _   / ___|___ | | ___  _ __ ___  __| |
# | |_ / _` | '_ \ / __| | | | | |   / _ \| |/ _ \| '__/ _ \/ _` |
# |  _| (_| | | | | (__| |_| | | |__| (_) | | (_) | | |  __/ (_| |
# |_|__\__,_|_| |_|\___|\__, |  \____\___/|_|\___/|_|  \___|\__,_|
# |  _ \ _ __ ___  _ __ |___/_ __ | |_                            
# | |_) | '__/ _ \| '_ ` _ \| '_ \| __|                           
# |  __/| | | (_) | | | | | | |_) | |_                            
# |_|   |_|  \___/|_| |_| |_| .__/ \__|                           
#                           |_|                                   
#===============================================================================

# Shows the weekday, time, user, server, and git branch.
# Feel free to tweak to your preferences.

# set a fancy prompt
if [ "$TERM" -a "$TERM" != "dumb" ]; then
    purple='\['`tput dim; tput setaf 5; tput setb 0`'\]'
    green='\['`tput bold; tput setaf 2; tput setb 0`'\]'
    cyan='\['`tput setaf 6`'\]'
    blue='\['`tput setaf 4`'\]'
    yellow='\['`tput dim; tput setaf 3`'\]'
	white='\['`tput bold; tput setaf 7; tput setb 0`'\]'
    redwh='\['`tput bold; tput setb 4; tput setaf 7`'\]'
    reset='\['`tput sgr0`'\]'
else
    # don't use colors if this is not a real interactive terminal
    purple=
    green=
    cyan=
    blue=
    yellow=
    redwh=
    reset=
fi
git_branch() {
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? == 0 ]; then
        cut -b 17-37 < ${GIT_DIR}/HEAD
    fi
}
dynamic_prompt() {
    GIT_BRANCH=$(git_branch)
    if [ "$USER" == 'root' ] ; then
        echo "$purple[\D{%w}.\t] $redwh\u$green@\h$cyan:$blue\w$yellow\$$reset "
    else
        if [ "$GIT_BRANCH" == '' ] ; then
            echo "$purple[\D{%w}.\t] $green\u@\h$cyan:$blue\w$yellow\$$reset "
        else
            echo "$purple[\D{%w}.\t] $green\u@\h$cyan:$blue\w$yellow (${GIT_BRANCH})\$$reset "
        fi
    fi
}
export PROMPT_COMMAND=$PROMPT_COMMAND$'; PS1=$(dynamic_prompt)'

# Looks like this (with color):
# [1.11:39:14] login@dev03:~/gsg-repo (XXX-1234)$
