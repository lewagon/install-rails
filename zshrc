ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(gitfast brew rbenv last-working-dir common-aliases sublime history-substring-search)
source $ZSH/oh-my-zsh.sh

export RBENV_ROOT=$HOME/.rbenv
export PATH="${RBENV_ROOT}/bin:${PATH}"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="./bin:/usr/local/bin:${PATH}"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
