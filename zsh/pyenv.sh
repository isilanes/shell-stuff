VENV_DIR=$HOME/local/python/virtualenv
ACTIVATE=$VENV_DIR/$1/bin/activate

if [[ -f $ACTIVATE ]]; then
    source $ACTIVATE
    if [[ "x$SHELL" == "x/usr/bin/zsh" ]]; then
        PS1=$'%{\e[35m%}[$(basename \"$VIRTUAL_ENV\")] '$_OLD_VIRTUAL_PS1
    elif [[ "x$SHELL" == "x/bin/bash" ]]; then
        PS1=$'\[\e[35m\][$(basename \"$VIRTUAL_ENV\")] '$_OLD_VIRTUAL_PS1
    fi
else
    echo No such virtualenv
    echo Available venvs:
    ls $VENV_DIR
fi
