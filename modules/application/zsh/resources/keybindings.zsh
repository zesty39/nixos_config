[[ ! -v functions[command_not_found_handler] ]] || unfunction command_not_found_handler

bindkey '^[[A' history-substring-search-up
bindkey '^P' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^N' history-substring-search-down
bindkey '\ef' emacs-forward-word
bindkey '^ ' autosuggest-accept
bindkey '^l' forward-word
