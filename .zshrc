PROMPT='%S%~ %#%s '

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

autoload -Uz compinit && compinit

# https://stackoverflow.com/a/26615036
cls() { clear && printf '\e[3J' }
dnt() { cls; dotnet test --no-restore }

ghpr() { gh pr list | fzf | cut -f 1 | xargs gh pr checkout }
