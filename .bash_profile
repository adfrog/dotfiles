export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/man:$MANPATH

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi