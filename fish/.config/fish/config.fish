if status is-interactive
    # Commands to run in interactive sessions can go here

    # atuin init fish | source
end

function starship_transient_prompt_func
    starship module character
end

# function fzf-bcd-widget -d 'cd backwards'
function fcd -d 'cd backwards'
    pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | tac | eval (__fzfcmd) +m --select-1 --exit-0 $FZF_BCD_OPTS | read -l result
    [ "$result" ]; and cd $result
    commandline -f repaint
end

function fs -d "Switch tmux session"
    tmux list-sessions -F "#{session_name}" | fzf | read -l result; and tmux switch-client -t "$result"
end

function fssh -d "Fuzzy-find ssh host via ag and ssh into it"
    # ag --ignore-case '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
    rg --ignore-case '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end

function fco -d "Fuzzy-find and checkout a branch"
    git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fco -d "Use `fzf` to choose which branch to check out" --argument-names branch
    set -q branch[1]; or set branch ''
    git for-each-ref --format='%(refname:short)' refs/heads | fzf --height 10% --layout=reverse --border --query=$branch --select-1 | xargs git checkout
end

function fcoc -d "Fuzzy-find and checkout a commit"
    git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end

function snag -d "Pick desired files from a chosen branch"
    # use fzf to choose source branch to snag files FROM
    set branch (git for-each-ref --format='%(refname:short)' refs/heads | fzf --height 20% --layout=reverse --border)
    # avoid doing work if branch isn't set
    if test -n "$branch"
        # use fzf to choose files that differ from current branch
        set files (git diff --name-only $branch | fzf --height 20% --layout=reverse --border --multi)
    end
    # avoid checking out branch if files aren't specified
    if test -n "$files"
        git checkout $branch $files
    end
end

function fzum -d "View all unmerged commits across all local branches"
    set viewUnmergedCommits "echo {} | head -1 | xargs -I BRANCH sh -c 'git log master..BRANCH --no-merges --color --format=\"%C(auto)%h - %C(green)%ad%Creset - %s\" --date=format:\'%b %d %Y\''"

    git branch --no-merged master --format "%(refname:short)" | fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$viewUnmergedCommits"
end

function fzf-complete -d 'fzf completion and print selection back to commandline'
    # As of 2.6, fish's "complete" function does not understand
    # subcommands. Instead, we use the same hack as __fish_complete_subcommand and
    # extract the subcommand manually.
    set -l cmd (commandline -co) (commandline -ct)
    switch $cmd[1]
        case env sudo
            for i in (seq 2 (count $cmd))
                switch $cmd[$i]
                    case '-*'
                    case '*=*'
                    case '*'
                        set cmd $cmd[$i..-1]
                        break
                end
            end
    end
    set cmd (string join -- ' ' $cmd)

    set -l complist (complete -C$cmd)
    set -l result
    string join -- \n $complist | sort | eval (__fzfcmd) -m --select-1 --exit-0 --header '(commandline)' | cut -f1 | while read -l r
        set result $result $r
    end

    set prefix (string sub -s 1 -l 1 -- (commandline -t))
    for i in (seq (count $result))
        set -l r $result[$i]
        switch $prefix
            case "'"
                commandline -t -- (string escape -- $r)
            case '"'
                if string match '*"*' -- $r >/dev/null
                    commandline -t -- (string escape -- $r)
                else
                    commandline -t -- '"'$r'"'
                end
            case '~'
                commandline -t -- (string sub -s 2 (string escape -n -- $r))
            case '*'
                commandline -t -- (string escape -n -- $r)
        end
        [ $i -lt (count $result) ]; and commandline -i ' '
    end

    commandline -f repaint
end

function field -d "Select field, including specifying the delimiter"
    set -l field_num $argv[1]
    set -l field_delim $argv[2]
    if test -z $field_num
        set field_num 1
    end
    if test -z $field_delim
        set field_delim " "
    end
    # awk -F "\${2:- }" "{ print \${1:-1} }"
    awk -F "$field_delim" "{ print \$$field_num }"
end

function total -d "Sum the total for a selected column"
    set -l field_num $argv[1]
    set -l field_delim $argv[2]
    if test -z $field_num
        set field_num 1
    end
    if test -z $field_delim
        set field_delim " "
    end

    awk -F "$field_delim" "{ s += \$$field_num } END { print s }"
end

alias dnfin="sudo dnf in"
alias dnfup="sudo dnf up --refresh"
alias dnfrm="sudo dnf remove"
alias flatupd="flatpak update"

alias x="exit"
# alias cp="xcp"

alias nv="/usr/bin/nvim"
alias vimdiff="nvim -d"
# alias nv='/home/rtorres/nvim-linux64/bin/nvim'

alias mkdir='mkdir -pv'

alias syncdir='rsync -r -auzvhP'
alias syncfiles='rsync -auzvhP'

alias kittyconf="nvim $HOME/.config/kitty/kitty.conf"
alias sshconfig="nvim $HOME/.ssh/config"
alias icat="kitten icat"

# Tmux
alias tmux="tmux"
alias txat="tmux attach"
alias txnew="tmux new -s"
alias txls="tmux list-sessions"
alias txkill="tmux kill-session -t"
alias txkillall="tmux kill-server"

# directories 
alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# Git 
alias lg="lazygit"
alias ga="git add"
alias gs="git status"
alias gsw="git switch"
alias gcm="git commit -m"
alias gpl="git pull"
alias gpp="git pull && git push"
alias gps="git push"

# make it easy to edit and source the config file
alias fishreload="source $HOME/.config/fish/config.fish"
alias fishconfig="nvim $HOME/.config/fish/config.fish"

alias ls="eza --icons --git --group-directories-first"
alias ll="eza --icons --long --header --tree --level=1 --header --git --hyperlink --group-directories-first"
alias la="eza --icons --long --header --tree --level=1 --git --hyperlink --group-directories-first --all"
# alias lt="eza --icons --long --tree --header --level=1 --hyperlink --group-directories-first"
# alias ltt="eza --icons --long --tree --header --level=2 --hyperlink --group-directories-first"

set -gx PATH $PATH "/home/rtorres/.local/bin"

set -gx EDITOR /usr/bin/nvim
# set -gx EDITOR "/home/rtorres/nvim-linux64/bin/nvim"
set -gx FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix"

# --border 
set -Ux FZF_DEFAULT_OPTS "\
--height 40% --tmux center,60%,40% --layout reverse \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"

set -gx FZF_COMPLETION_OPTS "--border --info=inline"

set -gx FZF_CTRL_R_OPTS "\
--preview 'echo {}' --preview-window up:3:hidden:wrap \
--bind 'ctrl-/:toggle-preview' \
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
--color header:italic \
--header 'Press CTRL-Y to copy command into clipboard'"

set -gx FZF_CTRL_T_OPTS "--walker-skip .git,node_modules,target \
--preview 'bat -n --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

set -gx FZF_ALT_C_OPTS "\
--walker-skip .git,node_modules,target \
--bind 'ctrl-/:toggle-preview' \
--preview 'eza --color=always --icons --tree --header --level=1 --group-directories-first {}'"

set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS "\
--bind 'ctrl-/:toggle-preview' \
--layout reverse --border"

set -gx SKIM_DEFAULT_OPTIONS "\
--border --height 20 --layout reverse"

set -Ux FZF_COMPLETION_TRIGGER '~~'
bind \t fzf-complete

set PATH $HOME/.cargo/bin $PATH
# Set up fzf key bindings
fzf --fish | source

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
set -gx MAMBA_EXE "/home/rtorres/.local/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/home/rtorres/.local/share/mamba"
$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<

zoxide init fish | source
starship init fish | source

enable_transience
