# -*- sh -*- vim:set ft=sh ai et sw=4 sts=4:
# It might be bash like, but I can't have my co-workers knowing I use zsh
PROMPT='
%{$fg[blue]%}┌%{$reset_color%}[%{$fg[green]%}%n@%m%{$reset_color%}] [%{$fg_bold[blue]%}%~%{$reset_color%}] $(git_prompt_info)
%{$fg[blue]%}└─%{$reset_color%}%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
