# vim:ft=zsh ts=4 sw=4 sts=4
# https://man.archlinux.org/man/zshmisc.1#EXPANSION_OF_PROMPT_SEQUENCES

setopt prompt_subst

# modified from agnoster
prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    echo -n "%{$bg%}%{$fg%} "
    [[ -n $3 ]] && echo -n $3
}

clearstyle() {
    echo -n '%{%f%b%k%}'
}

prompt_user() {
    prompt_segment default blue '%n@%m'
}

prompt_pwd() {
    local dir=$(shrink_path -f 2> /dev/null)
    [[ -z "$dir" ]] && dir='%(5~|%-1~/../%3~|%4~)'
    prompt_segment default default "$dir"
}

prompt_git() {
    prompt_segment default default "$(git_prompt_info)"
}

prompt_newline() {
    prompt_segment default default '\n'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
# modified from agnoster
prompt_status() {
    local -a symbols

    symbols+='%(?:%{%F{green}%}:%{%F{red}%})%?'
    [[ $UID -eq 0 ]] && symbols+='%{%F{yellow}%}r'
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+='%{%F{cyan}%}j'

    prompt_segment default default "[$symbols$(clearstyle)]"
}

prompt_end() {
    prompt_segment default default '>'
}

build_prompt_left() {
    clearstyle
    prompt_user
    prompt_pwd
    prompt_git
    prompt_newline
    prompt_end
    clearstyle
}

build_prompt_right() {
    clearstyle
    prompt_status
    clearstyle
}

PROMPT='$(build_prompt_left) '
RPROMPT='$(build_prompt_right)'

ZSH_THEME_GIT_PROMPT_PREFIX='(git:%{%F{yellow}%}'
ZSH_THEME_GIT_PROMPT_SUFFIX="$(clearstyle))"

ZSH_THEME_GIT_PROMPT_DIRTY=' %{%F{red}%}D'

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=' +'
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR='%{%F{green}%}'

ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=' -'
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR='%{%F{red}%}'
