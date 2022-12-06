# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
# Modified by isilanes (2018.09)
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

if [[ -f ~/.shell_theme ]]; then
  source ~/.shell_theme
else
  COLOR_FRONT_LIGHT=015
  COLOR_FRONT_DARK=016
  COLOR_VIRTUALENV_BACK=053
  COLOR_PATH_BACK=005
  COLOR_HIGH=012
fi

# Config:
VENV_FRONT_COLOR=$COLOR_FRONT_LIGHT
VENV_BACK_COLOR=$COLOR_VIRTUALENV_BACK
DIR_BACK_COLOR=$COLOR_PATH_BACK
DIR_FRONT_COLOR=$COLOR_FRONT_LIGHT
CONTEXT_BACK_COLOR=$COLOR_HIGH
CONTEXT_FRONT_COLOR=$COLOR_FRONT_DARK
RIGHT_SEPARATOR=$'\uE0B2'
TIME_SEPARATOR_COLOR=$COLOR_HIGH                  # 012
TIME_FRONT_COLOR=000                              # 017
UPTIME_SEPARATOR_COLOR=005                        # 032
UPTIME_FRONT_COLOR=$COLOR_FRONT_LIGHT             # 015
TIME_BACK_COLOR=$TIME_SEPARATOR_COLOR             # 012
UPTIME_SEPARATOR_BACK_COLOR=$TIME_SEPARATOR_COLOR # 012
UPTIME_BACK_COLOR=$UPTIME_SEPARATOR_COLOR         # 032
PREVIOUS_BG=   # leave it blank
CURRENT_BG='NONE'
NEXT_LINE_PROMPT_SYMBOL=$'\u276f'
NEXT_LINE_PROMPT_COLOR=176

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# Like prompt_segment above, but with 256 colors:
prompt_segment_256() {
    local bg fg

    # Background:
    if [[ "x$1" == "x" ]]; then
        bg="%k"
    elif [[ "x$1" == "xNONE" ]]; then
        bg="%k"
    else
        #bg="\e[48;5;${1}m"
        bg="$BG[$1]"
    fi

    # Foreground:
    if [[ "x$2" == "x" ]]; then
        fg="%f"
    elif [[ "x$2" == "NONE" ]]; then
        fg="%f"
    else
        #fg="\e[38;5;${2}m"
        fg="$FG[$2]"
    fi

    # Set colors:
    if [[ "x$PREVIOUS_BG" == "x" ]]; then
        echo -n "$bg$fg "
    else
        #echo -n " $bg\e[38;5;${PREVIOUS_BG}m${SEGMENT_SEPARATOR}${fg} "
        echo -n " $bg$FG[$PREVIOUS_BG]${SEGMENT_SEPARATOR}${fg} "
    fi

    # Print out text, if provided:
    [[ -n $3 ]] && echo -n $3

    # Save current bg to use as fg of following separator:
    PREVIOUS_BG=$1
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Like prompt_end, but for 256 colors:
prompt_end_256() {
  if [[ -n $PREVIOUS_BG ]]; then
      #echo -n " \e[38;5;4m${SEGMENT_SEPARATOR}\e[0m"
      #echo -n " \e[0m\e[38;5;${PREVIOUS_BG}m${SEGMENT_SEPARATOR}\e[0m"
      echo -n " %{$reset_color%}$FG[$PREVIOUS_BG]${SEGMENT_SEPARATOR}"
  else
      echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# If a next line is desired in prompt:
prompt_next_line() {
  echo -n "\n"
  PREVIOUS_BG=""
  prompt_segment_256 NONE $NEXT_LINE_PROMPT_COLOR "$NEXT_LINE_PROMPT_SYMBOL"
  echo -n " %{$reset_color%}$FG[$PREVIOUS_BG]"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
      #prompt_segment black default "%(!.%{%F{yellow}%}.)$USER@%m"
      prompt_segment_256 $CONTEXT_BACK_COLOR $CONTEXT_FRONT_COLOR "%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git_psa() {
  (( $+commands[git] )) || return
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green $CURRENT_FG
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}
prompt_git() {
    OUT=$(git_super_status_for_omz)

    # Exit early if not within git repo:
    if [[ "x$OUT" == "x" ]]; then
        return
    fi
     
    prompt_segment_256 000 000 $OUT
}

prompt_bzr() {
    (( $+commands[bzr] )) || return
    if (bzr status >/dev/null 2>&1); then
        status_mod=`bzr status | head -n1 | grep "modified" | wc -m`
        status_all=`bzr status | head -n1 | wc -m`
        revision=`bzr log | head -n2 | tail -n1 | sed 's/^revno: //'`
        if [[ $status_mod -gt 0 ]] ; then
            prompt_segment yellow black
            echo -n "bzr@"$revision "✚ "
        else
            if [[ $status_all -gt 0 ]] ; then
                prompt_segment yellow black
                echo -n "bzr@"$revision

            else
                prompt_segment green black
                echo -n "bzr@"$revision
            fi
        fi
    fi
}

prompt_hg() {
  (( $+commands[hg] )) || return
  local rev st branch
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green $CURRENT_FG
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green $CURRENT_FG
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
    LEN=$(echo $PWD | wc -c)
    if [ $LEN -lt 80 ]; then
        MSG='%~'
    else
        MSG=$(shrink_path -l $PWD)
    fi
    prompt_segment_256 $DIR_BACK_COLOR $DIR_FRONT_COLOR "$MSG"
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
    if [[ "x$VIRTUAL_ENV" != "x" ]]; then
        PRE=$(basename $VIRTUAL_ENV | sed -e 's/-/ /' | cut -d" " -f1)
        prompt_segment_256 $VENV_BACK_COLOR $VENV_FRONT_COLOR "$PRE"
    fi
}

# Conda: currently active Conda environment:
prompt_conda() {
    if [[ "x$CONDA_DEFAULT_ENV" != "x" ]]; then
        prompt_segment_256 $VENV_BACK_COLOR $VENV_FRONT_COLOR "$CONDA_DEFAULT_ENV"
    fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
    [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

    [[ -n "$symbols" ]] && prompt_segment_256 016 000 "$symbols"
}

formatted_uptime() {
    awk '{printf "%.1fd", $1/86400}' /proc/uptime
}

## Main prompt:
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_conda
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end_256
  prompt_next_line
}

# Disable the default virtualenv behaviour of prepending "(venvname)" to prompt:
export VIRTUAL_ENV_DISABLE_PROMPT=YES

# Finally, prompt:
PROMPT='%{%f%b%k%}$(build_prompt)'

# Right-side prompt:
S=$(prompt_segment_256 NONE $TIME_SEPARATOR_COLOR "$RIGHT_SEPARATOR")
T=$(prompt_segment_256 $TIME_BACK_COLOR $TIME_FRONT_COLOR %T)
T=$S$T

S=$(prompt_segment_256 $UPTIME_SEPARATOR_BACK_COLOR $UPTIME_SEPARATOR_COLOR "$SEPARATOR")
C=$(prompt_segment_256 $UPTIME_BACK_COLOR $UPTIME_FRONT_COLOR "")

RPROMPT='${T}${S}${C}$(formatted_uptime) %{$reset_color%}'
