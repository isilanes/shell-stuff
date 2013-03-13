# To install source this file from your .zshrc file

# Change this to reflect your installation directory
export __SVN_PROMPT_DIR=~/.zsh/svn-prompt

# Initialize colors.
autoload -U colors && colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook

add-zsh-hook chpwd chpwd_update_svn_vars
add-zsh-hook preexec preexec_update_svn_vars
add-zsh-hook precmd precmd_update_svn_vars

# Function definitions:
function preexec_update_svn_vars() {
    case "$2" in
        svn*)
        __EXECUTED_SVN_COMMAND=1
        ;;
    esac
}

function precmd_update_svn_vars() {
    if [ -n "$__EXECUTED_SVN_COMMAND" ] || [ -n "$ZSH_THEME_SVN_PROMPT_NOCACHE" ]; then
        update_current_svn_vars
        unset __EXECUTED_SVN_COMMAND
    fi
}

function chpwd_update_svn_vars() {
    update_current_svn_vars
}

function update_current_svn_vars() {
    unset __CURRENT_SVN_STATUS

    local svnstatus="$__SVN_PROMPT_DIR/svn_status.py"
    _SVN_STATUS=`python ${svnstatus}`
    __CURRENT_SVN_STATUS=("${(@f)_SVN_STATUS}")
        SVN_BRANCH=$__CURRENT_SVN_STATUS[1]
        SVN_TAG=$__CURRENT_SVN_STATUS[2]
        SVN_STATE=$__CURRENT_SVN_STATUS[3]
}

svn_super_status() {
    precmd_update_svn_vars
    if [ -n "$__CURRENT_SVN_STATUS" ]; then
        # In the prompt, info will appear as "(head|tail)", or "prefix head separator tail sufix" in general.

        # "head":
        if [[ $SVN_TAG != "None" ]]; then
            STATUS="${ZSH_THEME_SVN_PROMPT_PREFIX}${ZSH_THEME_SVN_PROMPT_TAG}${SVN_TAG}%{${reset_color}%}"
        else
            STATUS="${ZSH_THEME_SVN_PROMPT_PREFIX}${ZSH_THEME_SVN_PROMPT_BRANCH}${SVN_BRANCH}%{${reset_color}%}"
        fi

        # "separator":
        STATUS="${STATUS}${ZSH_THEME_SVN_PROMPT_SEPARATOR}"

        # "tail":

        if [[ $SVN_STATE == "dirty" ]]; then
            STATUS="${STATUS}${ZSH_THEME_SVN_PROMPT_DIRTY}"
        else
            STATUS="${STATUS}${ZSH_THEME_SVN_PROMPT_CLEAN}"
        fi

        STATUS="${STATUS}%{${reset_color}%}${ZSH_THEME_SVN_PROMPT_SUFFIX}"
        echo " $STATUS"
    fi
}

# Default values for the appearance of the prompt. Configure at will.
ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[blue]%}{"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$fg[blue]%}}"
ZSH_THEME_SVN_PROMPT_SEPARATOR="%{$fg[blue]%}|"
ZSH_THEME_SVN_PROMPT_BRANCH="%{$fg_bold[blue]%}"
ZSH_THEME_SVN_PROMPT_TAG="%{$fg_bold[yellow]%}"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg_bold[green]%}✔"
#
ZSH_THEME_SVN_PROMPT_CHANGED="%{$fg[blue]%}✚"
ZSH_THEME_SVN_PROMPT_STAGED="%{$fg[red]%}●"
ZSH_THEME_SVN_PROMPT_CONFLICTS="%{$fg[red]%}✖"
ZSH_THEME_SVN_PROMPT_REMOTE=""
ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg[red]%}*"
