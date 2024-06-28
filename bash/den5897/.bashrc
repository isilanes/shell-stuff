export HOME="/c/Users/u142774"
export PYENV="$HOME/.pyenv/pyenv-win"
export PYENV_ROOT="$HOME/.pyenv/pyenv-win/"
export PYENV_HOME="$HOME/.pyenv/pyenv-win/"
export PATH=$HOME/.pyenv/pyenv-win/bin:$HOME/.pyenv/pyenv-win/shims:$HOME/AppData/Roaming/Python/Scripts:$PATH

# User specific aliases and functions
if [ -f ~/.alias ]; then
    source ~/.alias
fi

# File colors:
#eval `dircolors -b $HOME/.dir_colors`

# Python:
export PYTHONPATH=$HOME/git/MonAPI:$PYTHONPATH
#export REQUESTS_CA_BUNDLE=$HOME/git/MonAPI/conf/certs/zscaler_root.pem  # just for pip

# History:
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %T "

# Prompt:
parse_git_branch() {
    BRANCH=$(git branch --show-current 2> /dev/null)
    if [[ "x$BRANCH" != "x" ]]; then
        echo -e "\e[38;5;39m$BRANCH\e[0m "
    fi
}
function set_win_title(){
    echo -ne "\033]0; $HOSTNAME \007"
}
starship_precmd_user_func="set_win_title"
eval "$(starship init bash)"
#eval "$(oh-my-posh init bash)"
#export PS1="[\e[38;5;14mlocal\e[0m \e[38;5;141m\w\e[0m]\n$ "
#export PS1="[\e[38;5;14mlocal\e[0m \e[38;5;141m\w\e[0m] \$(parse_git_branch)$ "
#export PS1="[\e[38;5;14m\u@\h\e[0m \e[38;5;141m\w\e[0m] \$(parse_git_branch)$ "
#export PS1="[\e[38;5;69minaki\e[38;5;15m@\e[38;5;69mironman\e[0m \e[38;5;141m\w\e[0m] \$(parse_git_branch)$ "
