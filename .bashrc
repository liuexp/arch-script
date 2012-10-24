#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


 # Workaround for tmux which resets the LANG
[[ "$LANG" == "C" ]] && export LANG="en_US.utf8"

export TERM="xterm-256color"
alias tmux="tmux -2"
alias l='ls -a'
alias ll='ls -l'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias :r='make'
alias :l='make $*'
alias :q='exit'
alias :ga='git add .'
alias :gc='git commit -a $*'
alias :gca='git commit -a $*'
alias :gp='git push'
alias :gs='git status $*'
alias :o='xdg-open $*'
PS1='[\u@\h \W]\$ '
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I_#P") "$PWD")'

PATH=$PATH:$HOME/.cabal/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

 #export XMODIFIERS=@im=fcitx
 #export GTK_IM_MODULE=xim
 #export QT_IM_MODULE=xim

