OK="\033[1;32m✔\033[0m"
KO='\e[1;31m✖\e[0m'

# Zsh
echo -e '\e[38;5;200m# Setting Zsh shell\e[0m'
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

echo ""
echo Will check spaceship next
echo Will copy dot files next
echo Will configure Tmux next
echo What next?
