# This is a shared bashrc file.
# You can
# 1) source this from your own .bashrc, ie. `. ~/dev/templates/shared_bashrc.sh`
# 2) copy this to your own .bashrc (which allows for easier customization, but
#    you lose out on nice additions)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export EDITOR="vim"
export CVSROOT="/var/lib/cvs"
export CVSEDITOR="vim"
export CVS_RSH="ssh"
export SVKROOT="/var/lib/svk"
export SVN_EDITOR="vim"
# export GNUPGHOME="/var/www/.gnupg" # optional
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
# uncomment the line below only if you work on TaxSys extensively
# PATH="/usr/local/gsgperl/tax-cbs/bin:$PATH"
export PATH PS1 PROMPT_COMMAND
# 'back 4' takes you back 4 directories.
back ()
{ 
    x=0 
    levels="" 
    while [ $x -lt $1 ]
        do
        levels="${levels}../"
        x=$[$x+1]
    done 
    cd $levels
}

# pvi Time::Local::Extended
pvi ()
{
    local file;
    file=$(perldoc -l $1);
    if [[ "$?" == "0" ]]; then
        vim $file;
    fi
}

# use man to get perldocs for Lots::Of::GSG::Modules
export MANPATH=/usr/local/gsgperl/gsg-epay/active/man:/usr/local/share/man:/usr/share/man/en:/usr/share/man

alias cu='cvs -q update -dP'
alias cm='cvs -q commit'
alias rs='sudo /usr/local/sbin/httpdctl --restart --cvs'
alias m='mysql -h devdb01m -u dbadmin --password=dba4dev01'
alias td='tail_all -S -c dev'
alias d='svk diff'
alias dd='svkc diff'
alias dn='cvs -q diff -buBwN'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
 
# Tab completion for user names on gitc submit|user-history and JIRA tickets on gitc open|edit|review
__gitc_complete() {
    compopt +o nospace; 
    case "$COMP_CWORD" in
    1)
        COMPREPLY=($(compgen -c "gitc-${COMP_WORDS[1]}" | sed s/gitc-//g ))
        ;;
    2)
        case "${COMP_WORDS[1]}" in
        submit)
            COMPREPLY=($(compgen -u ${COMP_WORDS[2]} ))
            ;;
        open | edit )
            COMPREPLY=($(dev-perl -MGSG::Gitc::Util=its -le '
                my $prefix = shift;
                my $jql = "assignee = currentUser() AND resolution = Unresolved ORDER BY updatedDate DESC";
                my $issues = its("jira")->get_jira_rest_object->search($jql)->{issues} || [];
                print for grep { /^\Q$prefix/ } map { $_->{key} } @$issues;
            ' "${COMP_WORDS[2]}"))
            ;;
        review )
            COMPREPLY=($(dev-perl -MGSG::Gitc::Util=its -le '
                my $prefix = shift;
                my $jql = q{resolution = Unresolved AND status = "in development" AND gitc ~ "pending review" and reviewer ~ currentUser() ORDER BY updatedDate DESC};
                my $issues = its("jira")->get_jira_rest_object->search($jql)->{issues} || [];
                print for grep { /^\Q$prefix/ } map { $_->{key} } @$issues;
            ' "${COMP_WORDS[2]}"))
            ;;
        setup)
            COMPREPLY=($(gitc-projects 2>/dev/null | grep "^${COMP_WORDS[2]}"))
                          ;;
        esac
        ;;
    3)
        case "${COMP_WORDS[1]}" in
        setup)
            COMPREPLY=($(echo "${COMP_WORDS[2]}" | grep "^${COMP_WORDS[3]}"))
            compopt -o nospace; 
            ;;
        user-history)
            COMPREPLY=($(compgen -u ${COMP_WORDS[3]} ))
            ;;
        esac
        ;;
    esac
}
complete -F __gitc_complete gitc
 
_bin_run_coverage_tests() 
{ 
    local cur=${COMP_WORDS[COMP_CWORD]} 
    COMPREPLY=( $(compgen -W '--uncommitted --verbose --critic --no-critic --no-config --all' -- $cur) ) 
} 
complete -F _bin_run_coverage_tests bin/run_coverage_tests.pl 


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
        echo "$purple[\D{%w}.\t] $redwh\u$white@\h$cyan:$blue\w$yellow\$$reset "
    else
        if [ "$GIT_BRANCH" == '' ] ; then
            echo "$purple[\D{%w}.\t] $white\u@\h$cyan:$blue\w$yellow\$$reset "
        else
            echo "$purple[\D{%w}.\t] $white\u@\h$cyan:$blue\w$yellow (${GIT_BRANCH})\$$reset "
        fi
    fi
}
export PROMPT_COMMAND=$PROMPT_COMMAND$'; PS1=$(dynamic_prompt)'

# Allow developers to add additional things to their .bashrc via a .bashrc.d directory.
# Each file will be read from the directory and sourced.

if [ -d ~/.bashrc.d ]; then
    for BASHFILE in $(find ~/.bashrc.d -type f)
    do
        . $BASHFILE
    done
fi

# Looks like this (with color):
# [1.11:39:14] login@dev03:~/gsg-repo (XXX-1234)$

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
