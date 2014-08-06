# Various useful shell tools #

## Vim ##

We include a .vim/ directory, and some .vimrc files.

### .vim/ ###

Copy or link the following directory:

    shell-stuff/vim/dotvim/

as:

    ~/.vim/

It is recommended that you use the NERDtree addon. For that:

   $ mkdir ~/.vim/bundle
   $ cd ~/.vim/bundle/
   $ git clone https://github.com/scrooloose/nerdtree.git 

### .vimrc files ###

We provide some .vimrc files, for different files, for example LaTeX or Python. I have to improve this, as filetype should be used for that.

Right now, to "install" them, copy or link:

    shell-stuff/vim/vimrcs

as:

    ~/.vimrcs

Then, to use one:

    $ alias vig='gvim -u ~/.vimrcs/program'
    $ vig file.py
   
## Zsh ##

### .zshrc ###

Copy or link the following files:

    shell-stuff/zsh/zshrc
    shell-stuff/zsh/inputrc.zsh
    shell-stuff/zsh/dir_colors
    shell-stuff/zsh/alias.zsh

respectively, as:

    ~/.zshrc
    ~/.inputrc.zsh
    ~/.dir_colors
    ~/.alias.zsh

### Git prompt ###

Zsh prompt addition for Git repos (prompt/git). Forked from:

https://github.com/olivierverdier/zsh-git-prompt

#### Install ####

    $ mkdir -p ~/.zsh/git-prompt
    $ cp prompt/git/* ~/.zsh/git-prompt/
    $ vi ~/.zshrc
    $ source ~/.zshrc

In the .zshrc editing step, modify your current PROMPT lines. My previous PROMPT value was:

    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}: '

For using the Git prompt I just added a function call to its end, and sourced a file:

    source $HOME/.zsh/git-prompt/zshrc.sh
    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(git_super_status): '

### Subversion prompt ###

Zsh prompt addition for Subversion repos (prompt/svn). Derived from zsh-git-prompt above.

#### Install ####

    $ mkdir -p ~/.zsh/svn-prompt
    $ cp prompt/git/* ~/.zsh/svn-prompt/
    $ vi ~/.zshrc
    $ source ~/.zshrc

In the .zshrc editing step, modify your current PROMPT lines. My previous PROMPT value was:

    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}: '

For using the Subversion prompt I just added a function call to its end, and sourced a file:

    source $HOME/.zsh/svn-prompt/svn.sh
    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(svn_super_status): '

You can use both prompts by sourcing both .sh files where appropriate, and using a compound PROMPT variable:

    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(git_super_status)$(svn_super_status): '
