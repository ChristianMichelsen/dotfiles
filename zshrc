# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/christianmichelsen/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/christianmichelsen/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/christianmichelsen/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/christianmichelsen/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export AUTOSWITCH_DEFAULT_CONDAENV="base"


### PLUGINS ###
[ -f ~/.zplug/init.zsh ] && source ~/.zplug/init.zsh

# Load oh-my-zsh plugins
zplug "plugins/brew",   from:oh-my-zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/github",   from:oh-my-zsh
zplug "plugins/osx",   from:oh-my-zsh

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"

zplug "arzzen/calc.plugin.zsh"

# zplug romkatv/powerlevel10k, as:theme, depth:1
# zplug "b4b4r07/enhancd"
# zplug "b4b4r07/enhancd", use:init.sh
zplug "junegunn/fzf"
zplug "Peltoche/lsd"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "skywind3000/z.lua"

zplug "bckim92/zsh-autoswitch-conda"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load #--verbose

# small fix to get calc to work
aliases[=]='noglob __calc_plugin'


### CONFIG ###

[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Add commonly used folders to $PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# LaTeX
export PATH="/Library/TeX/texbin/:$PATH"

# set Neovim to be editor
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Specify default editor. Possible values: vim, nano, ed etc.
export EDITOR=nvim


# fzf / ripgrep (rg) setup

bindkey "ç" fzf-cd-widget

# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# prevent ctrl+d from closing tab in iterm
set -o ignoreeof

# auto cd into folders without writing cd
setopt autocd
cdpath=($HOME $HOME/work;)


### ZSTYLE ###

# autocomplete with arrow keys
zstyle ':completion:*' menu select

# # let's use the tag name as group name
# zstyle ':completion:*' group-name ''

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# make completions appear below the description of which listing they come from
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' select-prompt %SScrolling active: current selection at %p%s

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true

# Always use menu selection for `cd -`
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# Pretty messages during pagination
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Show message while waiting for completion
zstyle ':completion:*' show-completer true


# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always


### ALIASES ###

alias g='git'

alias pure_hep_mount="sshfs mnv794@hep03.hpc.ku.dk:/lustre/hpc/hep/mnv794/work/ ~/hep -o defer_permissions -o volname=hep"
alias hep_mount="pure_hep_mount && (mysides remove hep || true) && mysides add hep file:///Users/christianmichelsen/hep/"
alias hep_unmount="umount -f ~/hep"
alias hep_connect2factor="ssh mnv794@otp.hpc.ku.dk"
alias mount_hep=hep_mount
alias unmount_hep=unhep_mount

alias pure_hep_mount_travel="sshfs fend01-travel:/groups/hep/mnv794/work/NetworkSIR ~/hep -o defer_permissions -o volname=hep"
alias hep_mount_travel="pure_hep_mount_travel && (mysides remove hep || true) && mysides add hep file:///Users/christianmichelsen/hep/"

alias pure_willerslev_mount="sshfs mnv794@ssh-snm-willerslev.science.ku.dk:/home/mnv794/ ~/willerslev -o defer_permissions -o volname=willerslev"
alias willerslev_mount="pure_willerslev_mount && (mysides remove willerslev || true) && mysides add willerslev file:///Users/christianmichelsen/willerslev/"

alias reload="source ~/.zshrc"

# LCD (ls with better colours)
alias ls='lsd'
alias l='ls -l'
alias lsa='ls -a'
alias la='ls -la'
alias lt='ls --tree'

# Quick access to the .zshrc file
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'

alias grep='grep --color'

alias untar='tar -zxvf' # Unpack .tar file
alias ping='ping -c 5' # Limit ping to 5'


### FUNCTIONS ###

# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

# play two videos side by side syncronized
function play2videos() {mpv --lavfi-complex='[vid1] [vid2] hstack [vo]' --loop "$1" --external-file="$2"}


# fd - Find any directory and cd to selected directory
fd() {
 local dir
 dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d \
      -print 2> /dev/null | fzf +m) &&
 cd "$dir"
}

### ZSH History config ###

setopt append_history
setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_lex_words
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history


