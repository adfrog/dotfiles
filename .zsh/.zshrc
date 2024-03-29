############################################################
## Environment variable configuration
#
# LANG
#
############################################################
#


export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac


#### 評価用スペース
#autoload -U predict-on # コマンドの予測入力(ヒストリ→一般補完)
#zle -N predict-on
#zle -N predict-off
#bindkey '^Xp' predict-on    # [C-x p] で有効化
#bindkey '^X^p' predict-off  # [C-x C-p] で無効化
#predict-on
# 面白いんだけど、コマンドラインの先頭に戻って編集するときにカーソル以降が全て消えるのが難点

autoload -U zmv
# % zmv '(*).jpeg' '$1.jpg'
# % zmv '(**/)foo(*).jpeg' '$1bar$2.jpg'
# % zmv -n '(**/)foo(*).jpeg' '$1bar$2.jpg' # 実行せずパターン表示のみ
# % zmv '(*)' '${(L)1}; # 大文字→小文字
# % zmv -W '*.c.org' 'org/*.c' #「(*)」「$1」を「*」で済ませられる
alias mmv='noglob zmv -W'  # 引数のクォートも面倒なので
# % mmv *.c.org org/*.c
#zmv -C # 移動ではなくコピー(zcp として使う方法もあるみたいだけど)
#zmv -L # 移動ではなくリンク(zln として使う方法もあるみたいだけど)

zstyle ':completion:*' use-compctl false # compctl形式を使用しない

# デフォルトでもユーザ名は /etc/passwd から、ホスト名は /etc/hosts から> 補完候補を持ってくる
#zstyle ':completion:*' users-hosts bar:foo.example.com funa@daemon

#  終了コードで色を変える
#PROMPT='%{%(?.$fg[green].$fg[red])%}PROMPTSTRING%{$reset_color%}'
#この例だと、終了コードが 0 のときは緑色、そうではないとき(=異常終了)は赤色になる。


 


############################################################
# redo?
# メモ
# cd -[tab] でディレクトリスタックを呼び出せる
# <1-20> パターンマッチ
# ESC C-h で区切り文字までのバックスペース
# killallコマンド
# ***/ シムリンクを辿る
# C-x g ワイルドカード展開結果をみる
# a=aiueo; echo $a[1] # 配列の扱い
# setopt multios(デフォルト)で複数リダイレクト、パイプ(「ls > 1.txt > 2.txt | less」)

#### 以下に書かれてないキーバインドは man zshzle の STANDARD WIDGETS を参照
# ESC-q (push-line)ディレクトリスタック
# C-x C-x       (exchange-point-and-mark)C-SPACE でマークした個所にジャンプ
# ESC-T (transpose-words)引数の前後交換
# ESC-. (insert-last-word)直前コマンドの最後の引数を呼び出す(繰り返し使える)、環境変数 _ も同様
# ESC-U (up-case-word)カーソル位置〜単語終端までを大文字に変更
# ESC-L (down-case-word)カーソル位置〜単語終端までを小文字に変更
# ESC-' (quote-line)コマンド行全体を '〜' で括る
# ESC-" (quote-region)マークした位置〜カーソル位置を '〜' で括る
# (未割当て)      (expand-cmd-path)コマンドをフルパスに展開
# C-x C-=       (what-cursor-position)カーソル位置にある文字コードを8、10、16進表示、カーソル位置を表示
# C-[   ESC と等価
# ESC-n (digit-argument)キー入力の回数指定(例：[ESC-4][ESC-0]-)
# ESC C-_       (copy-prev-word)カーソルの左にある単語をコピーしてペーストする
# C-x C-o       (overwrite-mode)挿入←→上書のモード切り替え

# 個人的キーバインドに使える C-キーバインド
# C-o, C-q, C-s
# C-c, C-g は入力中のコマンドが消えてしまうのを何とかする
# C-i   TAB でいい
# C-w   要改良
# C-v   特殊文字を置く。C-v C-i ならタブ文字、C-v C-j なら改行文字を置ける
# C-x 系コマンドを調べる。(C-x g みたいな)
# ■C-t の文字入れかえは使い勝手が良くないのでいらない → screen に使用
#### C-j or C-m どちらかで良い。→わけではない。skkinput で C-j を使う

#### メールチェック
## autoload -U colors; colors   # ↓のために。設定してなければしておく
# MAILCHECK=300                 # 300秒毎にチェック
## MAILPATH="/var/mail$USER"    # チェックするメールボックス
# MAILPATH="/var/mail$USER?{fg[red]}New mail"   # メッセージと色を変更

## --enable-maildir-support を指定してコンパイルすればMaildir 形式でも可能
# MAILPATH="$HOME/Maildir?{fg_bold[red]}New mail in $_" # 「$_」は変更されたfile
## : で区切れば複数のメールスプールをチェックできる
# MAILPATH="$HOME/Maildir?{fg_bold[red]}New mail in $_:$HOME/Maildir-foo?{fg_bold[green]}New mail in $_:"

# 環境変数 $TERM は gentoo を入れたデフォルトでは linux になっている

############################################################
# 環境変数は主に ~/.zshenv に記述
# ~/.zshrc に記述するのは、インタラクティブシェルとしての設定

# 画面の最大化で戻らなくなるのが不便
if [ ! $TERM = "screen"  ]; then
#if [ $TERM != 'screen' ]; then
case "${TERM}" in
  *xterm*|rxvt|(dt|k|E)term)
    if which tscreen >& /dev/null; then
        #exec tscreen -xRR
    elif which screen >& /dev/null; then
        exec screen -xRR
    else
        echo "screen をインストールしてください"
    fi
    ;;
esac
fi
autoload -U colors; colors      # ${fg[red]}形式のカラー書式を有効化

hosts=( localhost `hostname` )
#printers=( lw ph clw )
umask 002
cdpath=( ~ )                    # cd のサーチパス
#cdpath=(${HOME} ..)

    
fpath=(~/.zsh/functions/Completion ${fpath})    # zsh関数のサーチパス

#↓カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# cf. zstyle ':completion:*:path-directories' hidden true
# cf. cdpath 上のディレクトリは補完候補から外れる

#↓補完時に大小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' #C-w での単語区切りとして認識される文字
#        「*?_-.[]~=/&;!#$%^(){}<>」←WORDCHARS のデフォルト値

#### history
HISTFILE="$HOME/.zhistory"      # 履歴ファイル
HISTSIZE=6000000           # メモリ上に保存される $HISTFILE の最大サイズ？
SAVEHIST=6000000                  # 保存される最大履歴数

#### option, limit, bindkey
setopt extended_history         # コマンドの開始時刻と経過時間を登録
setopt hist_ignore_dups         # 直前のコマンドと同一ならば登録しない
setopt hist_ignore_all_dups     # 登録済コマンド行は古い方を削除
setopt hist_reduce_blanks # 余分な空白は詰めて登録(空白数違い登録を防ぐ)
#setopt append_history  # zsh を終了させた順にファイルに記録(デフォルト)
#setopt inc_append_history # 同上、ただしコマンドを入力した時点で記録
setopt share_history    # ヒストリの共有。(append系と異なり再読み込み不要、これを設定すれば append 系は不要)
setopt hist_no_store            # historyコマンドは登録しない
setopt hist_ignore_space # コマンド行先頭が空白の時登録しない(直後ならば呼べる)
# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups


setopt list_packed              # 補完候補リストを詰めて表示
setopt print_eight_bit          # 補完候補リストの日本語を適正表示
#setopt menu_complete  # 1回目のTAB で補完候補を挿入。表示だけの方が好き
setopt no_clobber               # 上書きリダイレクトの禁止
setopt no_unset                 # 未定義変数の使用の禁止
setopt no_hup                   # logout時にバックグラウンドジョブを kill しない
setopt no_beep                  # コマンド入力エラーでBEEPを鳴らさない
setopt AUTO_PUSHD               #ディレクトリスタックに自動的にプッシュ
setopt extended_glob            # 拡張グロブ
setopt numeric_glob_sort        # 数字を数値と解釈して昇順ソートで出力
setopt auto_cd                  # 第1引数がディレクトリだと cd を補完
setopt correct                  # スペルミス補完
setopt no_checkjobs             # exit 時にバックグラウンドジョブを確認しない
#setopt ignore_eof              # C-dでlogoutしない(C-dを補完で使う人用)
setopt pushd_to_home        # 引数なしpushdで$HOMEに戻る(直前dirへは cd - で)
setopt pushd_ignore_dups        # ディレクトリスタックに重複する物は古い方を削除
#setopt pushd_silent   # pushd, popd の度にディレクトリスタックの中身を表示しない
setopt interactive_comments     # コマンド入力中のコメントを認める
#setopt rm_star_silent          # rm * で本当に良いか聞かずに実行
#setopt rm_star_wait            # rm * の時に 10秒間何もしない
#setopt chase_links             # リンク先のパスに変換してから実行。
# setopt sun_keyboard_hack      # SUNキーボードでの頻出 typo ` をカバーする
# フローコントロールを無効にする
# 今時役に立たない。むしろ邪魔
setopt no_flow_control
# = の後はパス名として補完する
setopt magic_equal_subst
## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
autoload zed

limit   coredumpsize    0       # コアファイルを吐かないようにする

stty    erase   '^H'
stty    intr    '^C'
stty    susp    '^Z'

#### bindkey
# bindkey "割当てたいキー" 実行させる機能の名前
bindkey -e    # emacs 風キーバインド(環境変数 EDITOR も反映するが、こっちが優先)
bindkey '^I'    complete-word   # complete on tab, leave expansion to _expand



# 今入力している内容から始まるヒストリを探す
# tcsh風先頭マッチのヒストリサーチ(カーソルが行末)
# 不便と思う。カーソル位置を編集することも多いし、行末へは C-e ですぐ飛べるし
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^P" history-beginning-search-backward-end
# bindkey "^N" history-beginning-search-forward-end
bindkey '^P' history-beginning-search-backward # 先頭マッチのヒストリサーチ
bindkey '^N' history-beginning-search-forward # 先頭マッチのヒストリサーチ


# run-help が呼ばれた時、zsh の内部コマンドの場合は該当する zsh のマニュアル表示
[ -n "`alias run-help`" ] && unalias run-help
autoload run-help

#### completion
_cache_hosts=(localhost $HOST hashish loki3 mercury
  Li He Pt Au Ti{1,2} Ni{1,2} Co{1..8} Zn{1..8}
  192.168.0.1 192.168.1.1
)
#_cache_hosts=(`perl -ne  'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`)
# ↑(_cache_hosts) ~/.ssh/known_hosts から自動的に取得する

# 強力な補完機能を有効にする
autoload -U compinit; compinit -u -d ${HOME}/.zcompdump
compdef _tex platex             # platex に .tex を


# 補完される前にオリジナルのコマンドまで展開してチェックされる
setopt complete_aliases
############################################################
## プロンプト設定
unsetopt promptcr       # 改行のない出力をプロンプトで上書きするのを防ぐ
setopt prompt_subst             # ESCエスケープを有効にする

#if [ $TERM = "rxvt" ] || [ $TERM = "xterm" ]; then
if [ $COLORTERM = 1 ]; then
  if [ $UID = 0 ] ; then 
    PSCOLOR='00;04;31'
  else
    if [ $host = 'hashish' ] ; then
        PSCOLOR='00;04;35'
    elif [ $host = 'mercury' ] ; then
        PSCOLOR='00;04;36'
    elif [ $host = 'Pt' ] ; then
        PSCOLOR='00;04;32'
    else
        PSCOLOR='00;04;33'
    fi
  fi
  RPS1=$'%{\e[${PSCOLOR}m%}[%~]%{\e[00m%}'    # 右プロンプト
  #PS1=$'%{\e]2; %m:%~ \a'$'\e]1;%%: %~\a%}'$'\n%{\e[${PSCOLOR}m%}%n@%m %#%{\e[00m%} '
  #PS1=$'%{\e]2; %m:%~ \a'$'\e]1;%%: %~\a%}'$'\n%{\e[${PSCOLOR}m%}%n@%m ${WINDOW:+"[$WINDOW]"}%#%{\e[00m%} ' #kterm
  PS1=$'%{\e]2; %m:%~ \a'$'\e]1;%%: %~\a%}'$'\n%{\e[${PSCOLOR}m%}%n@%m ${WINDOW:+"[$WINDOW]"}%#%{\e[00m%} '
  # 1個目の $'...' は 「\e]2;「kterm のタイトル」\a」
  # 2個目の $'...' は 「\e]1;「アイコンのタイトル」\a」
  # 3個目の $'...' がプロンプト
  #
  # \e を ESC コード(で置く必要があるかも
  # emacs では C-q ESC, vi では C-v ESC で入力する
  #       \e[00m  初期状態へ
  #       \e[01m  太字    (0は省略可能っぽい)
  #       \e[04m  アンダーライン
  #       \e[05m  blink(太字)
  #       \e[07m  反転
  #       \e[3?m  文字色をかえる
  #       \e[4?m  背景色をかえる
  #               ?= 0:黒, 1:赤, 2:緑, 3:黄, 4:青, 5:紫, 6:空, 7:白
else    
  PS1="%n@%m %~ %# "
fi


#### time
REPORTTIME=8                    # CPUを8秒以上使った時は time を表示
TIMEFMT="\
    The name of this job.             :%J
    CPU seconds spent in user mode.   :%U
    CPU seconds spent in kernel mode. :%S
    Elapsed time in seconds.          :%E
    The  CPU percentage.              :%P"

#### ログインの監視
# log コマンドでも情報を見ることができる
watch=(notme) # (all:全員、notme:自分以外、ユーザ名,@ホスト名、%端末名
              # (列挙；空白区切り、繋げて書くとAND条件)
LOGCHECK=60                     # チェック間隔[秒]
WATCHFMT="%(a:${fg[blue]}Hello %n [%m] [%t]:${fg[red]}Bye %n [%m] [%t])"
# ↑では、a (ログインかログアウトか)で条件分岐している
# %(a:真のメッセージ:偽のメッセージ)
# a,l,n,m,M で利用できる。	
# ■使える特殊文字
# %n    ユーザ名
# %a    ログイン/ログアウトに応じて「logged on」/「logged off」
# %l    利用している端末名
# %M    長いホスト名
# %m    短いホスト名
# %S〜%s        〜の間を反転
# %U〜%u        〜の間をアンダーライン
# %B〜%b        〜の間を太字
# %t,%@ 12時間表記の時間
# %T    24時間表記の時間
# %w    日付(曜日 日)
# %W    日付(月/日/年)
# %D    日付(年-月-日)


############################################################
# screen
############################################################
# ターミナルの種類に応じてウィンドウに表示する文字を変更

case "$TERM" in
xterm*|kterm*|rxvt*)
    # screenを起動してない時はここを通る
echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
;;
screen*)

    # screen起動時はここを通る
    printf "\033P\033]0;$USER@$host\007\033\\"
    function change_screen_title() {
        echo -n "k$1:t\\"
    }

    preexec() {
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
        fg)
            if (( $#cmd == 1 )); then
                cmd=(builtin jobs -l %+)
            else
                cmd=(builtin jobs -l $cmd[2])
            fi
            ;;

        %*)
            cmd=(builtin jobs -l $cmd[1])
            ;;
        vim|vi)
            if (( $#cmd == 2)); then
                cmd[1]="v:$cmd[2]"
            fi
            change_screen_title "$cmd[1]"
            return
            ;;
        emacs)
            if (( $#cmd == 3)); then
                cmd[1]="e:$cmd[3]"
            fi
            change_screen_title "$cmd[1]"
            return
            ;;
        cd)
            if (( $#cmd == 2)); then
                cmd[1]=$cmd[2]
            fi
            change_screen_title "$cmd[1]"
            return
            ;;
        *)
            change_screen_title "$cmd[1]"
            return
            ;;
        esac

            local -A jt; jt=(${(kv)jobtexts})

            $cmd >>(read num rest
            cmd=(${(z)${(e):-\$jt$num}})
            change_screen_title "$cmd[1]"
        ) 2>/dev/null
    }
    precmd(){
        change_screen_title "$(basename `dirs`)"
    }

      
    ;;
esac

: << '#COMMENT_OUT'
テスト
Ctrl-A	行頭へジャンプ
Ctrl-E	行末へジャンプ
Ctrl-Y	ヤンク
Ctrl-X U	アンドゥ
Ctrl-@	マークセット
Ctrl-K	カーソルから行末までを削除
Ctrl-W	カーソルから行頭までを削除
Ctrl-U	一行削除
Ctrl-G	コマンド入力を実行せずに無視して次の行へ
Ctrl-B	←キー
Ctrl-F	→キー
Ctrl-P	↑キー
Ctrl-N	↓キー
Ctrl-D	Deleteキー
Ctrl-H	BackSpaceキー
Ctrl-I	展開または補完
Ctrl-L	クリアスクリーン

Ctrl-X Ctrl-F	vi風文字一致検索
Ctrl-X Ctrl-V	viコマンドモード
Ctrl-X Ctrl-U	アンドゥ
#COMMENT_OUT


autoload -Uz vcs_info
zstyle ':vcs_info:*' formats ':(%s)%b'
zstyle ':vcs_info:*' actionformats ':(%s)%b|%a'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
PROMPT="%{${fg[yellow]}%}[%n@%m%1(v|%F{green}%1v%f|)%{${fg[yellow]}%}]%{${reset_color}%}%b "

############################################################
# load user configuration file
############################################################
#
# aliases
if [ -e ~/.zsh/.zaliases ]; then
    source ~/.zsh/.zaliases
fi

# hostname
case "${HOST}" in
    *.local);
    if [ "darwin" = ${ARCHI} -a -e $ZDOTDIR/.zshrc_${ARCHI} ]; then
        source $ZDOTDIR/.zshrc_${ARCHI}
    fi ;;

    *sakura.ne.jp);
    if [ -e $ZDOTDIR/.zshrc_sakura ]; then
        source $ZDOTDIR/.zshrc_sakura
    fi ;;

esac


# username
