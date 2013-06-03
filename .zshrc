# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=20000
setopt appendhistory extendedglob
unsetopt nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/comex/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
export KEYTIMEOUT=1
export PS1="%~ %% "
. ~/.stuff
bk() { bindkey "$1" "$2"; bindkey -a "$1" "$2" }
bk "^A" beginning-of-line
bk "^E" end-of-line
bk "^[b" vi-backward-word
bk "^[f" forward-word
bk "^R" history-incremental-search-backward
unfunction bk

# the difference is important
bindkey "^[^?" backward-kill-word # option-del
bindkey "^W" backward-delete-word    # vi-backward-kill-word
bindkey "^H" backward-delete-char  # vi-backward-delete-char
bindkey "^U" kill-line             # vi-kill-line
bindkey "^?" backward-delete-char  # vi-backward-delete-char

#zstyle ':zle:backward-delete-word*' word-chars ''
#zstyle ':zle:*' word-chars "$WORDCHARS"
#zstyle ':zle:*' word-chars ''
#zstyle ':zle:*' word-style standard

autoload -U select-word-style
select-word-style bash
fpath=(~/.zshfunctions $fpath)
autoload forward-word-match
zle -N forward-word forward-word-match
