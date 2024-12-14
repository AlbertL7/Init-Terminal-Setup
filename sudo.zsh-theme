# -*- sh -*- vim:set ft=sh ai et sw=4 sts=4:

PROMPT='%{$(echo "\e[1;38;2;255;0;0m")%}%n@%m[☠️ ]%{$fg_bold[blue]%}%2~ $(git_prompt_info)%{$reset_color%}%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
