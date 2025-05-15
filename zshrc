export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="garyblessington"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export PYENV_ROOT="$HOME/.pyenv" 
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH" 
eval "$(pyenv init - bash)" 
eval "$(pyenv virtualenv-init -)" 

