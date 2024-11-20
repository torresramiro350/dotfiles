# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"
# Fig pre block. Keep at the top of this file.
# # .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc

export PATH="/home/rtorres/.cargo/env:$PATH"
export PATH="/home/rtorres/.cargo/bin:$PATH"
# eval "$(starship init bash)" # starship shell

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
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
# <<< conda initialize <<<
. "$HOME/.cargo/env"
eval "$(starship init bash)"
eval "$(atuin init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/rtorres/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/rtorres/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
