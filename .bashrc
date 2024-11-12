dnt() { cls; dotnet test --no-restore }

ls_absolute() {
    find  "$@" -maxdepth 1
}

ghpr() {
    pr=$(gh pr list | fzf | cut -f1)
    if [[ ! -z $pr ]]; then
        gh pr checkout $pr;
    fi
}
ghprw() {
    gh pr view --web
}

gec() {
    gitextensions commit
}
ge() {
    gitextensions .
}

ii() {
    explorer "$@"
}
