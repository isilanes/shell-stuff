WHICH=$1
BASEDIR=$HOME/git/GitHub/shell-stuff/screen

if [ -f $BASEDIR/screenrc.$1 ]; then
    screen -S $1 -c $BASEDIR/screenrc.$1
else
    echo No such screenrc
    echo Available screenrcs:
    ls $BASEDIR/screenrc.*
fi
