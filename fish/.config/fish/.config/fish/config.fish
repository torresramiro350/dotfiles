if status is-interactive
    # Commands to run in interactive sessions can go here
end

function starship_transient_prompt_func
  # starship module character
  starship module time
end

function fzf-bcd-widget -d 'cd backwards'
	pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | tac | eval (__fzfcmd) +m --select-1 --exit-0 $FZF_BCD_OPTS | read -l result
	[ "$result" ]; and cd $result
	commandline -f repaint
end

function fs -d "Switch tmux session"
  tmux list-sessions -F "#{session_name}" | fzf | read -l result; and tmux switch-client -t "$result"
end

function fssh -d "Fuzzy-find ssh host via ag and ssh into it"
  ag --ignore-case '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end

function fzf-bcd-widget -d 'cd backwards'
	pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | tac | eval (__fzfcmd) +m --select-1 --exit-0 $FZF_BCD_OPTS | read -l result
	[ "$result" ]; and cd $result
	commandline -f repaint
end

# === BEGINNING OF GIT RELATED FUNCTIONALITY ===
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

# === END OF GIT RELATED FUNCTIONALITY ===


alias bat='bat --theme=Catppuccin-mocha'
set -gx EDITOR /usr/bin/nvim
set fzf_history_time_format 
set fzf_fd_opts --hidden --max-depth 5
set fzf_preview_dir_cmd eza --all --icons --color=always
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set -x FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
# according to the GitHub repo this is a bad idea: 
# set -x FZF_DEFAULT_OPTS "--reverse --border --height 40% \
# --preview 'bat  --style=numbers --color=always --line-range :500 {}'" 

set -x FZF_DEFAULT_OPTS "--reverse --border --height 50% \
--info=inline --border --margin=1 --padding=1"
set -Ux FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

set -x FZF_CTRL_T_OPTS "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# turn on vim keybindings for the fish shell
# === WEZTERM ===
# alias wezterm="flatpak run org.wezfurlong.wezterm"

# === GENERAL SHORTCUTS ===
alias fishreload="source $HOME/.config/fish/config.fish"
alias fishconfig="nvim $HOME/.config/fish/config.fish"
alias r="reset"
alias st="speedtest-cli"
alias c="clear"
alias ht="htop"

# === LAZYGIT ===
alias lg="lazygit"

alias vi="nvim"
alias nv="nvim"
alias svi="sudo nvim"

alias nvconfig="nv ~/.config/nvim/init.lua"

# === Changing directories ===
alias .1='cd ..'
alias .2.='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# === Trash ===
alias tl="trash-list"
alias tp="trash-put"
alias tc="trash-empty"


# alias vsc="code --ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer ."
# alias vsc="code --enable-features=UseOzonePlatform --ozone-platform=wayland ."
alias vsc="code ."

alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias kittyconftheme="nvim ~/.config/kitty/current-theme.conf"
alias kittythemes="kitty +kitten themes"
alias icat="kitty +kitten icat"
alias d="kitty +kitten diff"

alias starconfig="nv ~/.config/starship.toml"

# === System reboot/shutdown ===
alias ssn="sudo shutdown now"
alias sr="sudo reboot"

# === ALIASES WHEN USING FEDORA ===
alias updates="dnf check-update"
alias upgrade="sudo dnf5 upgrade --refresh"
alias search="sudo dnf5 search"
alias install="sudo dnf5 install"
alias uninstall="sudo dnf5 remove"

# === CONDA ALIASES ===
alias condalistenvs='conda info --envs'
alias condain='conda install'
alias condainit='conda activate' # activate environment
alias condarmenv='conda remove --all --name' # remove enviornment and all its packages
alias condalist='conda list' # list all installed packages in current environment
alias condaclean='conda clean --all' #clean unused packages


# === LS ALIASES ===
alias ls="eza --icons --git --group-directories-first"
alias ll="eza --long --all --icons --header -R --git --no-permissions -T -L 1"
alias la="eza --long --all -R -H -T -L 1 --header"

alias lt="eza -T --long --header -L 1 --group-directories-first"
alias ltt="eza -T --long --header -L 2 --group-directories-first"
alias lT="eza -lT --long --header -L 3 --group-directories-first"

alias df='df -h'

# === CONFIRMATIONS
alias rm="rm -i"
# alias mv="mv -i -g"   # patched version of move cmd
alias mv="mv -i"   # patched version of move cmd
# alias cp="cp -i -g" # patched version of copy cmd
alias cp="xcp -v" # patched version of copy cmd
alias cpdir="xcp -v -r" # patched version of copy cmd

# file transfer
alias syncdir="rsync -r -auzvhP"
alias syncfiles="rsync -auzvhP"

# === COPILOT ALIASES ===
alias copilot="gh copilot explain"

# === GIT ALIASES ===
alias gs="git status"
# add already tracked files
alias gau="git add -u"
# add new items to git repo
alias ga="git add"
# commit with message
alias gcm="git commit -m"
# switch branches
alias gsw="git switch"
# checkout another branch
alias gco="git checkout"
# pull from remote
alias gpl="git pull"
# push to remote
alias gps="git push"
#merger branch into current branch
alias gmg="git merge"

# === GITHUB CLI ===
alias ghl="gh issue list"
alias ghc="gh issue create"
alias ghv="gh issue view"

fzf_configure_bindings --directory=\e\cf --processes=\e\cp --git_status=\e\cs --git_log=\e\cl

# set -gx 

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/rtorres/miniforge3/bin/conda
    eval /home/rtorres/miniforge3/bin/conda "shell.fish" "hook" $argv | source
end

if test -f "/home/rtorres/miniforge3/etc/fish/conf.d/mamba.fish"
    source "/home/rtorres/miniforge3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<
starship init fish | source
zoxide init fish | source
enable_transience

