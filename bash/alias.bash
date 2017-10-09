# List:
alias ls='ls --color=auto -F -b -T 0'
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -lhrt'
alias lh='ls -lh'

# Ask before screwing up:
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'

# rsync-related:
alias sind='rsync -rltouvh --progress --dry-run --delete --no-whole-file '
alias sindt='rsync -rltouvh --progress --delete --no-whole-file '
alias sin='rsync -rltouvh --progress --dry-run --no-whole-file '
alias sint='rsync -rltouvh --progress --no-whole-file '

# SGE-related:
alias qa="qstat -u '*'"
alias qm="qm.py"

# Other:
alias h='history 1'
alias seek='find ./* -name'
alias df="df -h"

# Other:
alias pyenv='source ~/git/GitHub/shell-stuff/zsh/pyenv.sh'
