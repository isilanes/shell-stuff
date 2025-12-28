OK="\033[1;32m✔\033[0m"
KO='\e[1;31m✖\e[0m'

FORCE=0
if [ "$1" = "-f" ]; then
    FORCE=1
fi

# Zsh
echo -e '\e[38;5;200m# Setting Zsh\e[0m'
for FILE in zshrc alias.zsh
do
    DOTFILE=$HOME/.$FILE
    ORIGIN=../zsh/$FILE
    if [ -f $DOTFILE ]; then
        if [ $FORCE = 0 ]; then
            echo -e "$OK \e[34m$DOTFILE\e[0m exists. Skipping."
        else
            echo -e "$OK \e[34m$DOTFILE\e[0m exists. Overwriting with $ORIGIN."
            cp $ORIGIN $DOTFILE
        fi
    else
        echo -e "$KO \e[34m$DOTFILE\e[0m does not exist. Copying from $ORIGIN"
        cp $ORIGIN $DOTFILE
    fi
done

if [ "${SHELL##*/}" = zsh ]; then
    echo -e "[$OK] Already running Zsh"
else
    echo -e "$KO Not running Zsh"
    ZSH=$(which zsh)
    if [[ "$ZSH" == "" ]]; then
        echo -e "$KO Zsh not installed"
        echo -e Please install the '\e[34mzsh\e[0m' package and run this script again afterwards
        exit
    else
        echo -e "$OK Zsh is installed"
        echo -e Making '\e[34mzsh\e[0m' the default shell...
        chsh -s $ZSH
        echo The shell change will only be visible AFTER you log-in again
    fi
fi

# Zsh
echo -e '\e[38;5;200m# Setting Alacritty\e[0m'

echo ""
echo Will check spaceship next
echo Will copy dot files next
echo Will configure Tmux next
echo What next?
