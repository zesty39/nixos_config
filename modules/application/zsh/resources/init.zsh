typeset -U path PATH
path=("$HOME/.local/bin" $path)

WORDCHARS=${WORDCHARS//[\/]}
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

ZIM_HOME=${HOME}/.zim
source ${ZIM_HOME}/init.zsh
