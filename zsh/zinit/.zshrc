# https://www.youtube.com/watch?v=ud7YxC33Z3w
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p $ZINIT_HOME
    git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
fi

source $ZINIT_HOME/zinit.zsh

# Zsh plugins:
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

autoload -U compinit && compinit

# Starship:
eval "$(starship init zsh)"

# Keybindings (don´t seem to work):
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History:
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion styling:
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Alias:
[[ ! -f ~/.alias.zsh ]] || source ~/.alias.zsh

# Shell integrations:
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

# Pyenv:
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(dircolors -b ~/.dir_colors)"
