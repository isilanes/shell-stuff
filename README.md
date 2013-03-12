# Various useful tools for Zsh #

## Git prompt ##

Zsh prompt addition for Git repos (prompt/git). Forked from:

https://github.com/olivierverdier/zsh-git-prompt

### Install ###

  $ mkdir -p ~/.zsh/git-prompt
  $ cp prompt/git/* ~/.zsh/git-prompt/
  $ vi ~/.zshrc
  $ source ~/.zshrc

In the .zshrc editing step, modify your current PROMPT lines. My previous PROMPT value was:

    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}: '

For using Git prompt I just added a function call to its end, and sourced a file:

    source $HOME/.zsh/git-prompt/zshrc.sh
    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(git_super_status): '

## Subversion prompt ##

Zsh prompt addition for Subversion repos (prompt/svn). Derived from zsh-git-prompt above.

### Install ###

    $ mkdir -p ~/.zsh/svn-prompt
    $ cp prompt/git/* ~/.zsh/svn-prompt/
    $ vi ~/.zshrc
    $ source ~/.zshrc

In the .zshrc editing step, modify your current PROMPT lines. My previous PROMPT value was:

    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}: '

For using Git prompt I just added a function call to its end, and sourced a file:

    source $HOME/.zsh/svn-prompt/svn.sh
    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(svn_super_status): '

You can use both prompts by sourcing both .sh files where appropriate, and using a compound PROMPT variable:

    PROMPT=$'%{\e[32m%}${HOST}[%{\e[33m%}%~%{\e[32m%}]%{\e[0m%}$(git_super_status)$(svn_super_status): '
