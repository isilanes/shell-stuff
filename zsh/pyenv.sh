VENV_DIR=$HOME/local/python/virtualenv
ACTIVATE=$VENV_DIR/$1/bin/activate

if [[ -f $ACTIVATE ]]; then
    source $ACTIVATE
    PS1=$'%{\e[35m%}[$(basename \"$VIRTUAL_ENV\")] '$_OLD_VIRTUAL_PS1
else
    echo No such virtualenv
    echo Available venvs:
    ls $VENV_DIR
fi
