" ==================== Basic settins ==================== "
" General
set nocompatible     " 
set viminfo+=!       " add '!' for YankRing plugin
"set shellslash       " to use '/' for path delimiter in Windows
set visualbell t_vb=     "beep & フラッシュも

" Tab character
set tabstop=4 shiftwidth=4 softtabstop=0
set expandtab   " use space instead of tab
set smartindent " smart indent

" Input support
set backspace=indent,eol,start " to delete everything with backspace key
set formatoptions+=m           " add multibyte support

" Command completion
set wildmenu                   " enhance command completion
set wildmode=list:longest,full " first 'list:lingest' and second 'full'

" Searching
set wrapscan   " search wrap around the end of the file
set ignorecase " ignore case
set smartcase  " override 'ignorecase' if the search pattern contains upper case
set incsearch  " incremental search
set hlsearch   " highlight searched words

" Reading and writing file
set nobackup   " don't backup
set autoread   " auto reload when file rewrite other application
set noswapfile " don't use swap file

" Display
set showmatch         " 括弧の対応をハイライト
set showcmd           " 入力中のコマンドを表示
set number            " 行番号表示
set wrap              " 画面幅で折り返す
set list              " 不可視文字表示
set listchars=tab:>\  " 不可視文字の表示方法
set notitle           " タイトル書き換えない
set scrolloff=5       " 行送り
set nolinebreak       " 改行しない
set textwidth=0       " 改行しない



" カレントウィンドウのみラインを引く
augroup cch
    autocmd! cch
    " autocmd WinLeave * set nocursorcolumn nocursorline
    " autocmd WinEnter,BufRead * set cursorcolumn cursorline
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

" Folding
set foldmethod=marker
" 行頭でhを押すと折りたたみを閉じる
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" 折りたたみ上でlを押すと折りたたみを開く
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo' : 'l'
" 行頭でhを押すと選択範囲に含まれる折りたたみを閉じる
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折りたたみ上でlを押すと選択範囲に含まれる折りたたみを開く
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv' : 'l'

" bufbuf
nnoremap <silent> <F4> <Esc>:call BufBufLauncher(1)<CR>


" Status line
set laststatus=2
set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v(ASCII=%03.3b,HEX=%02.2B)\ %l/%L(%P)%m

" File encoding
if has('mac')
    set encoding=utf-8
elseif has('win32')
    set encoding=japan
endif
set fileencodings=utf-8,cp932,euc-jp

" File Formats
set ffs=unix,dos,mac

" For multibyte characters, such as □, ○
set ambiwidth=double

" File type
syntax on " syntax coloring
colorscheme desert
" colorcheme pablo
" colorcheme koehler


" Hightlight Zenkaku space
highlight ZenkakuSpace ctermbg=darkcyan ctermfg=darkcyan
match ZenkakuSpace /　/

set complete+=k    " to use dictionary for completion
filetype indent on " to use filetype indent
filetype plugin on " to use filetype plugin

" Dictionary
augroup Dictionary
    autocmd! Dictionary
    autocmd FileType javascript setlocal dictionary+=~/.vim/dict/javascript.dict
    autocmd FileType php setlocal dictionary+=~/.vim/dict/php.dict
augroup END

" Omni completion
set completeopt+=menuone " 補完表示設定

" TabでOmni補完及びポップアップメニューの選択
inoremap <silent> <expr> <CR> (pumvisible() ? "\<C-e>" : "") . "\<CR>"
inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

" ポップアップメニューの色変える
highlight Pmenu ctermbg=lightcyan ctermfg=black 
highlight PmenuSel ctermbg=blue ctermfg=black 
highlight PmenuSbar ctermbg=darkgray 
highlight PmenuThumb ctermbg=lightgray

" Disable input methods
set iminsert=0
set imsearch=0
" set noimdisable

" ==================== キーマップ ==================== "
" 表示行単位で移動
nnoremap j  gj
nnoremap k  gk
nnoremap gj j
nnoremap gk k
nnoremap 0  g0
nnoremap g0 0
nnoremap $  g$
nnoremap g$ $

vnoremap j  gj
vnoremap k  gk
vnoremap gj j
vnoremap gk k
vnoremap 0  g0
vnoremap g0 0
vnoremap $  g$
vnoremap g$ $


" Delete highlight
nnoremap <silent> gh :nohlsearch<CR>

" Expand path
cnoremap <expr> <C-x> expand('%:p:h') . "/"
cnoremap <expr> <C-z> expand('%:p:r') 

" Copy and paste
" Command-C and Command-V are also available in MacVim
" Reference:
" http://subtech.g.hatena.ne.jp/cho45/20061010/1160459376
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
"
" need  'set enc=utf-8' and
" below environment variable for UTF-8 characters
" export __CF_USER_TEXT_ENCODING='0x1F5:0x08000100:14'
"
" Vim(Mac)
if has('mac') && !has('gui')
    nnoremap <silent> <Space>y :.w !pbcopy<CR><CR>
    vnoremap <silent> <Space>y :w !pbcopy<CR><CR>
    nnoremap <silent> <Space>p :r !pbpaste<CR>
    vnoremap <silent> <Space>p :r !pbpaste<CR>
" GVim(Mac & Win)
else
    noremap <Space>y "+y
    noremap <Space>p "+p
endif

" Enable mouse wheel
" In Mac, Only on iTerm.app, disable on Terminal.app
if has('mac')
    set mouse=a
    set ttymouse=xterm2
endif

" Binary (see :h xxd)
" vim -b :edit binary using xxd-format!
" reference: http://jarp.does.notwork.org/diary/200606a.html#200606021
augroup Binary
    autocmd! Binary
    autocmd BufReadPre   *.bin,*.swf let &bin=1
    autocmd BufReadPost  *.bin,*.swf if &bin | silent %!xxd -g 1
    autocmd BufReadPost  *.bin,*.swf set ft=xxd | endif
    autocmd BufWritePre  *.bin,*.swf if &bin | %!xxd -r
    autocmd BufWritePre  *.bin,*.swf endif
    autocmd BufWritePost *.bin,*.swf if &bin | silent %!xxd -g 1
    autocmd BufWritePost *.bin,*.swf set nomod | endif
augroup END

" ==================== プラグインの設定 ==================== "
" 基本的に<Space>に割り当てとけばかぶらない？

" ctags
" MacPortsのPrivatePortsで入るのはjexctags
set tags=./tags,./TAGS,tags,TAGS
if has('mac')
    command! CtagsR !jexctags -R --tag-relative=no --fields=+iaS --extra=+q
endif

if has('win32')
    command! CtagsR !ctags -R --tag-relative=no --fields=+iaS --extra=+q
endif

" Ruby
augroup Ruby
    autocmd! Ruby
    autocmd FileType ruby,eruby,yaml setlocal softtabstop=2 shiftwidth=2 tabstop=2
augroup END

" CakePHP
au BufNewFile,BufRead *.thtml setfiletype php
au BufNewFile,BufRead *.ctp setfiletype php

" NERD_comments
let NERDSpaceDelims = 1
let NERDShutUp = 1

" NERD_tree
nnoremap <silent> <Space>t :NERDTreeToggle<CR>

" FuzzyFinder
nnoremap <silent> <Space>fb :FuzzyFinderBuffer<CR>
nnoremap <silent> <Space>ff :FuzzyFinderFile<CR>
nnoremap <silent> <Space>fm :FuzzyFinderMruFile<CR>
nnoremap <silent> <Space>fc :FuzzyFinderMruCmd<CR>
nnoremap <silent> <C-]> :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>

let g:AutoComplPop_IgnoreCaseOption = 0
let g:AutoComplPop_CompleteoptPreview = 1
let g:AutoComplPop_Behavior = {
    \   'javascript' : [
    \       {
    \           'command'  : "\<C-n>",
    \           'pattern'  : '\k\k$',
    \           'excluded' : '^$',
    \           'repeat'   : 0,
    \       },
    \       {
    \           'command'  : "\<C-x>\<C-f>",
    \           'pattern'  : (has('win32') || has('win64') ? '\f[/\\]\f*$' : '\f[/]\f*$'),
    \           'excluded' : '[*/\\][/\\]\f*$\|[^[:print:]]\f*$',
    \           'repeat'   : 1,
    \       },
    \       {
    \           'command'  : "\<C-x>\<C-o>",
    \           'pattern'  : '\k\.$',
    \           'excluded' : '^$',
    \           'repeat'   : 0,
    \       },
    \   ],
    \   }

" Reload Firefox {{{
" Need MozRepl and +ruby
function! ReloadFirefox()
    if has('ruby')
        ruby <<EOF
        require "net/telnet"

        telnet = Net::Telnet.new({
            "Host" => "localhost",
            "Port" => 4242
        })

        telnet.puts("content.location.reload(true)")
        telnet.close
EOF
    endif
endfunction
nnoremap <silent> <Space>rf :<C-u>call ReloadFirefox()<CR>
" }}}

" Reload Safari {{{
" Need RubyOSA and +ruby
function! ReloadSafari()
    if has('ruby') && has('mac')
        ruby <<EOF
        require 'rubygems'
        require 'rbosa'

        safari = OSA.app("Safari")
        safari.do_javascript("location.reload(true)", safari.documents[0])
EOF
    endif
endfunction
nnoremap <silent> <Space>rs :<C-u>call ReloadSafari()<CR>
" }}}

" visual studio
" if has('win32')
    " let g:visual_studio_python_exe = "C:/Python25/python.exe"
" endif

" git
let git_diff_spawn_mode = 1
augroup git
    autocmd! git
    autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal filetype=git
augroup END

" TeXShop {{{
" Need RubyOSA and +ruby
function! TexShop_TypeSet()
    if has('ruby') && has('mac')
        ruby <<EOF
        unless $texshop
            require 'rubygems'
            require 'rbosa'

            $texshop = OSA.app("TeXShop")
        end
        $texshop.documents.each {|d|
            $texshop.typesetinteractive(d)
        }
EOF
    endif
endfunction

augroup tex
    autocmd! tex
    autocmd FileType tex noremap <buffer> <silent> ,t :<C-u>call TexShop_TypeSet()<CR>
"    autocmd FileType tex setlocal spell spelllang=en_us
augroup END
" }}}

" Utility command for Mac
if has('mac')
    command! Here silent exe '!open ' . expand('%:p:h') . '/'
    command! This silent exe '!open %'
    command! Cot  silent exe '!open -a CotEditor %'
endif

" TOhtml
let html_number_lines = 0
let html_use_css = 1
let use_xhtml = 1
let html_use_encoding = "utf-8"

" Others
command! HTMLEscape silent exe "rubydo $_ = $_.gsub('&', '&amp;').gsub('>', '&gt;').gsub('<', '&lt;').gsub('\"', '&quot;')"

" Load private information
" source ~/.vimrc_passwords

" tex
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
" set grepprg=grep\ -nH\ $*
" let g:Tex_DefaultTargetFormat='pdf'
" let g:Tex_FormatDependency_pdf='dvi,pdf'
" let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
" let g:Tex_ViewRule_dvi = ''
" let g:Tex_ViewRule_ps  = ''
" let g:Tex_ViewRule_pdf = 'open -a /Applications/Preview.app'
" let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
" augroup LatexSuite
"   au LatexSuite User LatexSuiteFileType
"    \ imap <silent> <buffer> -- <Plug>Tex_FastEnvironmentInsert
" augroup END
" augroup MyTexImaps
"   autocmd!
"   autocmd FileType tex imap <buffer> :i <A-i> "Mac で Alt-i が使えないから
"   autocmd FileType tex imap <buffer> :l <A-l>
"   autocmd FileType tex imap <buffer> :j <C-j>
"   autocmd FileType tex imap <buffer> :5 <F5>
"   autocmd FileType tex inoremap <buffer> :d $
"   autocmd FileType tex inoremap <buffer> :p %
"   autocmd FileType tex inoremap <buffer> :h ^
"   autocmd FileType tex inoremap <buffer> :u _
"   autocmd FileType tex inoremap <buffer> :[ {
"   autocmd FileType tex inoremap <buffer> :] }
"   autocmd FileType tex setl grepprg=grep\ -nH\ $*
"   autocmd FileType tex setl makeprg=rake
" augroup END
"
" ウィンドウを閉じずにバッファを閉じる
function! <SID>BufcloseCloseIt() 
    let l:currentBufNum = bufnr("%") 
    let l:alternateBufNum = bufnr("#") 
    
    if buflisted(l:alternateBufNum) 
        buffer # 
    else 
        bnext 
    endif 
    
    if bufnr("%") == l:currentBufNum 
        new 
    endif 
    
    if buflisted(l:currentBufNum) 
        execute("bwipeout ".l:currentBufNum) 
    endif 

endfunction command! Bclose call <SID>BufcloseCloseIt() 

" SETTING: RUNTIME DIR: ------------------------------------------------- {{{1

function! s:enumDirs(dir)
  return map(split(glob(fnamemodify(a:dir, ':p') . '*/'), "\n"), 'fnamemodify(v:val, '':h'')')
endfunction

function! s:isVimRuntimeDir(dir)
  return fnamemodify(a:dir, ':t') =~ '^vimfiles\|^vim-'
endfunction

function! s:enumVimRuntimeDirs(dirRepos)
  let runtimeDirs = []
  for dir in s:enumDirs(a:dirRepos)
    if s:isVimRuntimeDir(dir)
      call add(runtimeDirs, dir)
    else
      let runtimeDirs += filter(s:enumDirs(dir), 's:isVimRuntimeDir(v:val)')
    endif
  endfor
  return runtimeDirs
endfunction
function! s:initRuntimePath(dirsRuntime)
  let dirsAfter = map(copy(a:dirsRuntime), 'v:val . "/after"')
  let dirsHelp = map(copy(a:dirsRuntime), 'v:val . "/doc"')
  let &runtimepath = join(a:dirsRuntime + [&runtimepath] + dirsAfter, ',')
  for dirs in dirsHelp
    if filereadable(glob(dirs . '/*.txt'))
      let $DOCDIRS = dirs
      helptags $DOCDIRS
    endif
  endfor
endfunction

" let s:dirRepos = expand('<sfile>:p:h:h:h')
let s:dirRepos = $HOME . "/.vim"
let s:dirsRuntime = s:enumVimRuntimeDirs(s:dirRepos)
call s:initRuntimePath(s:dirsRuntime)

" vim:set foldmethod=marker:
