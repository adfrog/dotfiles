############################################################
# ARCHI
############################################################
if [ -x /usr/bin/uname ] || [ -x /bin/uname ]; then
    case "`uname -sr`" in
        FreeBSD*); export ARCHI="freebsd" ;;
        Linux*);   export ARCHI="linux"   ;;
        CYGWIN*);  export ARCHI="cygwin"; export LC_ALL=C ;;
        IRIX*);    export ARCHI="irix"    ;;
        OSF1*);    export ARCHI="osf1"    ;;
        Darwin*);    export ARCHI="darwin"     ;;
        *);        export ARCHI="dummy"   ;;
    esac
else
    export ARCHI="dummy"
fi

############################################################
# HOST
############################################################

if [ -x /bin/hostname ]; then
    export HOST=`hostname`
fi;
export host=`echo $HOST | sed -e 's/\..*//'`


############################################################
# 各種 zshファイルの場所 dir
############################################################

ZDOTDIR=${HOME}/.zsh
export ZDOTDIR

############################################################
# path / PATH
############################################################

userpath=( \
    $HOME/local/bin /usr/local/bin /opt/local/bin /bin /opt/local/sbin \
    /usr/local/teTeX/bin /sbin /usr/bin /usr/sbin /usr/local/sbin \
    $HOME/bin $HOME/private/bin \
    $HOME/tanaka-share/trunk/ruby \
    /usr/X11R6/bin /usr/games \
    /usr/bsd(N) /usr/bin/X11 /usr/bin/X11 /usr/i18n/bin /home/program/bin \
    /usr/users/program/msi/MS21/CASTEP/bin \
    /usr/people/msi/cerius2_4.2MS/bin \
    /usr/opt/MPI195/bin /usr/local/MPICH/bin \
    /usr/home/program/VASP/bin /usr/home/program/msi/MS22/CASTEP/bin \
    /cygdrive/d/DVXA/EXEC \
    $path
    )
addpath=()      # 確定した候補を入れていく受け皿
for i in "${userpath[@]}"; do   # 受け皿に追加していく
    chksame=0
    if [ -d $i ]; then      # システムにディレクトリが存在しなければ飛ばす
        addpath=( $addpath $i )
    fi
done
path=( $addpath )
unset userpath addpath i # 後始末
typeset -U path
MANPATH=$HOME/local/man:/usr/local/share/man:/usr/share/man:/usr/X11R6/man

############################################################
export UID

export CC=`which gcc`
export JLESSCHARSET="japanese"
export FTP_PASSIVE_MODE="NO"


export GNUSTEP_USER_ROOT="$HOME/.GNUstep"
export LC_COLLATE=C
export LC_TIME=C
export PERL_BADLANG=0
export XMODIFIERS='@im=uim'
export SHELL=`which zsh`


export LD_LIBRARY_PATH="/opt/intel_fc_80/lib:/opt/intel_fc_81/lib:\
/usr/lib:/usr/lib/compat/aout:\
/usr/X11R6/lib:/usr/X11R6/lib/aout:\
/usr/local/lib:/usr/local/lib/compat/pkg"





#### $COLORTERM 
export COLORTERM=0
case "$TERM" in 
    xterm*);	COLORTERM=1 ;;  # putty
    mlterm*);	COLORTERM=1 ; TERM='kterm-color';;
    screen*);	COLORTERM=1 ;;
    ct100*);	COLORTERM=1 ;;	# TeraTermPro
    kterm*);	COLORTERM=1 ; TERM='kterm-color'
      export LANG=ja_JP.UTF8;   #w3m とか mutt とかに必要
      export LC_ALL=ja_JP.UTF8;;
    #vim は TERM='kterm' ではカラー化しない
    #screen は TERM='kterm-color' ではタイトルバーに情報表示できない
esac

