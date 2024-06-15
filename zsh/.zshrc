# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# append code completions
fpath+=/home/rtorres/conda-zsh-completion
fpath+=/home/rtorres/atuin_completions
fpath+=/home/rtorres/zsh_completions_dir/trash_completions
fpath+=/home/rtorres/zsh-completions/src
fpath+=/home/rtorres/.zfunc

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# export ZSH="/usr/share/oh-my-zsh"
# HIST_IGNORE_ALL_DUPS
# HIST_FIND_NO_DUPS
# Show this many history lines when pressing ⌃R or ⌃S.

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when its time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#

#
# source ~/.zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh

plugins=(
    sudo
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-autocomplete
    # dnf
    # vscode
    # autojump
    # fast-syntax-highlighting
)

# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# bindkey '\e[A' up-line-or-history
# bindkey '\eOA' up-line-or-history
# bindkey '\e[B' down-line-or-history
# bindkey '\eOB' down-line-or-history


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR='nvim'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nvim'
else
    export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# === ALIASES SECTION ===
alias wifipwd="nmcli device wifi show-password"
alias weather="curl wttr.in"
alias c="clear"
alias x="exit"
alias h="history"
alias hc="history -c"
alias hg="history | grep"
alias s="kitty +kitten ssh"

# expressvpn aliases
alias exvpncon="expressvpn connect"
alias exvpnstat="expressvpn status"
alias exvpndis="expressvpn disconnect"
alias exvpnlist="expressvpn list"


alias ht="htop"
alias st="speedtest-cli"

# grep with color and show the line
alias grep="grep -n --color"

#show current OS release
alias distro="cat /etc/*-release"

# launch browser (for me its chrome)
alias browser="chrome"

# launch vscode
alias vsc="code --ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer ."

alias vi="nvim"
alias nv="nvim"
alias svi="sudo nvim"

# === confirmations
alias rm="rm -i"
# alias mv="mv -i -g"   # patched version of move cmd
alias mv="mv -i"   # patched version of move cmd
# alias cp="cp -i -g" # patched version of copy cmd
alias cp="xcp -v" # patched version of copy cmd
alias cpdir="xcp -v -r" # patched version of copy cmd

# file transfer
alias syncdir="rsync -r -auzvhP"
alias syncfiles="rsync -auzvhP"

#listing files
# alias ls="exa --icons --git --group-directories-first"
alias ls="eza --icons --git --group-directories-first"
alias ll="ls --long --header -R --git --no-permissions -T -L 1"
alias la="ls --long --all -R -H -T -L 1 --header"

# lsd has more icons :)
# list files in long format, sorted by date,
# oldest first
# alias ls="lsd -lStr"
# list files in long format, sorted by
# date modied, oldest first in human readable form
# alias ll="lsd -lStrha"

# alias for tree
alias tree="ls -T --only-dirs -L 1"
alias tree2="ls -T --only-dirs -L 2"
alias tree3="ls -T --only-dirs -L 3"

# create directories
alias mkdir="mkdir -pv"

# compare contents of two files with colored syntax
# using the colordiff command
alias diff="colordiff"

#aliases for git
alias ga="git add"
alias gs="git status"
alias gcl="git clone"
alias gcm="git commit -m"
alias gpp="git pull && git push"
alias gft="git fetch"
alias gps="git push"
alias gpl="git pull"
alias gaa="git add --all"
alias gconf="git config --global"
alias gconflst="git config --global --list"
alias gtag="git tag"
alias gnwtag="git tag -a"


alias ssn="sudo shutdown now"
alias sr="sudo reboot"

#configure zsh
alias zshconfig="nvim ~/.zshrc"
alias zshreload="source ~/.zshrc"

#customize kitty terminal
alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias kittyconftheme="nvim ~/.config/kitty/current-theme.conf"
alias kittythemes="kitty +kitten themes"
alias icat="kitty +kitten icat"
alias d="kitty +kitten diff"

# starship config
alias starconfig="nv ~/.config/starship.toml"

# alacritty themes
alias at="alacritty-themes"

#configure vim
alias vimconfig="vim ~/.vimrc"
alias nvconfig="nvim ~/.config/nvim/lua/user/init.lua"

# SSH
alias sshconfig="nvim $HOME/.ssh/config"
alias ssh-crispin="kitty +kitten ssh -Y crispin"
alias ssh-gala="kitty +kitten ssh gala"
alias ssh-tango="kitty +kitten ssh tango"
alias ssh-fiesta="kitty +kitten ssh -Y fiesta"

# update flatpaks
alias flatupd="flatpak update"
alias flatinstall="flatpak install flathub"

# === ALIASES WHEN USING FEDORA
alias dnfcheck="dnf check-update"
alias upgrade="sudo dnf upgrade --refresh"
alias search="dnf search"
alias install="sudo dnf install"
alias uninstall="sudo dnf remove"

# === ALIASES WHEN USING ARCH ===
# alias pacsyu='sudo pacman -Syyu' # update only standard packages
# alias yaysua='yay -Sua --noconfirm' #update only AUR pkgs
# alias yaysyu='yay -Syu --noconfirm' # update standard pks and AUR pkgs
# alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # remove orphanaged packages (act with caution!)
# alias unlock='sudo rm /var/lib/pacman/db.lck' #remove pacman lock
#
# alias updkernellist='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# navigation
alias .1='cd ..'
alias .2.='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# conda aliases
alias condalistenvs='conda info --envs'
alias condain='conda install'
alias condainit='conda activate' # activate environment
alias condarmenv='conda remove --all --name' # remove enviornment and all its packages
alias condalist='conda list' # list all installed packages in current environment
alias condaclean='conda clean --all' #clean unused packages


alias df='df -h'

# launch fv
alias fv="$HOME/fv5.5.2/fv"
alias ds9="$HOME/fv5.5.2/ds9"

export PATH="/home/rtorres/.cargo/env:$PATH"
export PATH="/home/rtorres/.local/bin:$PATH"
export PATH="/home/rtorres/.dprint/bin:$PATH"
export PATH="/home/rtorres/.cargo/bin:$PATH"
#
export GTK_IM_MODULE='ibus'
export QT_IM_MODULE='ibus'
export XMODIFIERS='@im=ibus'

setopt hist_ignore_dups

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Improving zsh :)
zstyle ':autocomplete:*' min-input 2 # wait for two characters before auto completion starts
zstyle ':autocomplete:*' min-delay 0.05 # wait for 0.05 seconds after done typing to appear
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands

# If there are fewer than this many lines below the prompt, move the prompt up
# to make room for showing this many lines of completions (approximately).

# Mamba Configuration
# <<< conda initialize <<<
__conda_setup="$('/home/rtorres/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rtorres/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/rtorres/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rtorres/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/rtorres/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/home/rtorres/miniforge3/etc/profile.d/mamba.sh"
fi

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(starship init zsh)" # starship shell
eval "$(atuin init zsh)"
