cdpath=(.. ~ ~/Documents)

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

umask 022

# Set up aliases
alias rm='nocorrect rm'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
source ~/git/GitHub/shell-stuff/zsh/alias.zsh

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Global aliases -- These do not have to be
# at the beginning of the command line.
#alias -g M='|more'
#alias -g L='|less'
#alias -g H='|head'
#alias -g T='|tail'

# Hosts to use for completion (see later zstyle)
#hosts=(`hostname` ftp.math.gatech.edu prep.ai.mit.edu wuarchive.wustl.edu)

# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent clobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash
setopt   nohup
unsetopt autoremoveslash

# Autoload zsh modules when they are referenced
#zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

#bindkey -v               # vi key bindings
#bindkey -e               # emacs key bindings

bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

# Custom dircolors:
eval `dircolors -b $HOME/.dir_colors`

# Set the prompt line:
setopt promptsubst
source $HOME/.zsh/git-prompt/zshrc.sh
source $HOME/.zsh/svn-prompt/svn.sh
if [[ $HOST == "burns" ]]; then
    PROMPT=$'%{\e[32;1m%}${HOST}[%{\e[0;32m%}%~%{\e[32;1m%}]%{\e[0m%}$(git_super_status)$(svn_super_status): '
    RPROMPT=$'%{\e[32m%}%T%{\e[37m%}·%{\e[36m%}$(awk \'{printf "%.1f",$1/86400}\' /proc/uptime)%{\e[0m%}'
elif [[ $HOST == "frink" ]]; then
    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(git_super_status): '
    RPROMPT=$'%{\e[32m%}%T%{\e[0m%}'
elif [[ $HOST == "Moe" ]]; then
    PROMPT=$'%{\e[32;1m%}${HOST}[%{\e[0;32m%}%~%{\e[32;1m%}]%{\e[0m%}$(git_super_status)$(svn_super_status): '
    RPROMPT=$'%{\e[32m%}%T%{\e[37m%}·%{\e[36m%}$(awk \'{printf "%.1f",$1/86400}\' /proc/uptime)%{\e[0m%}'
elif [[ $HOST == "skinner" ]]; then
    PROMPT=$'%{\e[34m%}${HOST}[%{\e[36;1m%}%~%{\e[0;34m%}]%{\e[0m%}$(git_super_status): '
    RPROMPT=$'%{\e[36m%}%T%{\e[0m%}'
elif [[ $HOST == "raspberrypi" ]]; then
    PROMPT=$'%{\e[31m%}${HOST}[%{\e[35m%}%~%{\e[0;31m%}]%{\e[0m%}$(git_super_status): '
    RPROMPT=$'%{\e[31m%}%T%{\e[0m%}'
elif [[ $HOST == "fry" ]]; then
    PROMPT=$'%{\e[34m%}${HOST}[%{\e[0;36m%}%~%{\e[34m%}]%{\e[0m%}$(git_super_status)$(svn_super_status): '
    #PROMPT=$'%{\e[34m%}${HOST}[%{\e[0;36m%}%~%{\e[34m%}]%{\e[0m%}: '
    RPROMPT=$'%{\e[34m%}%T%{\e[37m%}·%{\e[36m%}$(awk \'{printf "%.1f",$1/86400}\' /proc/uptime)%{\e[0m%}'
else
    PROMPT=$'%{\e[32m%}${HOST}[%{\e[32;1m%}%~%{\e[0;32m%}]%{\e[0m%}$(git_super_status): '
    RPROMPT=$'%{\e[32m%}%T%{\e[0m%}'
fi

# History stuff:
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[OA" history-beginning-search-backward-end
bindkey "^[OB" history-beginning-search-forward-end

# Path:
path=($path ~/local/bin . /usr/local/bin /home/isilanes/local/python/miniconda3/bin)

# ENV vars:
#export PERL5LIB=${PERL5LIB}:${HOME}/MyTools/PerlModules
#export PYTHONPATH=${PYTHONPATH}:${HOME}/lib/python
export MANPATH=${MANPATH}:/usr/share/man:$X11HOME/man:/usr/man:/usr/lang/man:/usr/local/man
export EDITOR=vim
export BIBINPUTS=$BIBINPUTS:.:Config
export BSTINPUTS=$BSTINPUTS:.:Config
export TEXINPUTS=$TEXINPUTS:.:Config
if [[ $TERM == "xterm" ]]; then
    export TERM=xterm-256color
fi

# bindkeys:
source ~/.inputrc.zsh

# Powerline:
source ~/.particular

# Conda:
CONDASH=$HOME/local/python/miniconda3/etc/profile.d/conda.sh
if [[ -a $CONDASH ]]; then
    . $CONDASH
fi
