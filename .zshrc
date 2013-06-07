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
case "`hostname`" in
nicholas-allegras-macbook-pro.local)
    export PS1="%~ %% ";;
nallegra-goobuntu.mtv.corp.google.com)
    export PS1="%F{blue}%~ \$ %f";;
*)
    export PS1="%F{red}%~ @ %f";;
esac
    
. ~/.stuff
bk() { bindkey "$1" "$2"; bindkey -a "$1" "$2" }
bk "^A" beginning-of-line
bk "^E" end-of-line
bk "^[b" vi-backward-word
bk "^[f" forward-word
bk "^R" history-incremental-search-backward
bk "^[^?" backward-kill-word # option-del
bk "^W" backward-delete-word    # vi-backward-kill-word
bk "^[[H" beginning-of-line
bk "^[[F" end-of-line
bk "^[[3~" delete-char
bk "^[[1;3D" vi-backward-word
bk "^[[1;3C" forward-word
unfunction bk

# the difference is important
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

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls --color=auto'
