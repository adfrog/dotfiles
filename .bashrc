if [ -x `which zsh` ]; then
    echo '[switch login shell] bash -> zsh'
    exec zsh -l
    exit 0
fi
