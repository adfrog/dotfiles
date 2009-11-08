" bufbuf.vim
" 2009.08.01  K
" ver 1.2.4


if exists('g:BufBufLoaded')
  finish
endif
let g:BufBufLoaded = 1



"----tunable parameters for users-------
let g:BufBufListMoveMode = 1
let g:BufBufLoadOnlyModeEnable = 0
let g:BufBufShowUnloadMark = 0
let g:BufBufShowNamelessBuf = 0
let g:BufBufVerWindowWidth = 36
let g:BufBufFileNameLength = 20
let g:BufBufNameless = "[nameless]"
let g:BufBufEmptyMsg0 = "No buffer listed.\n"
let g:BufBufEmptyMsg1 = "This buffer is unloaded.\n\tType 'l' to load.\n\tType 'x' to unload."
let g:BufBufTmpBufName = "__BUFBUF__"
let g:BufBufEmptyBufName = "__EMPTY__"
let g:BufBufLoadOnlyInit = 0
let g:BufBufMoveOutDirection = 0



"-----------inner parameters-----------
" these parameters are not constant
let g:BufBufFirst = 1
let g:BufBufMode = 0
let g:BufBufLoadOnly = 0
let g:BufBufIdList = []
let g:BufBufIdListLoadOnly = []
let g:BufBufCurIdList = []
let g:BufBufAnotherIdList = []
let g:BufBufListWinId = 0
let g:BufBufTargetWinId = 0
let g:BufBufLastBufId = 0
let g:BufBufTmpBufId = -1
let g:BufBufEmptyBufId = -1
let g:BufBufRegEscapeTmp = []
let g:BufBufEmptyMessageLast = ""
let g:BufBufCurDir = ""



"---------setting for users-------------
"
function!  BufBufSetModeSimple(iMode)
	if a:iMode == 1	" simple mode
		let g:BufBufListMoveMode = 1
		let g:BufBufShowUnloadMark = 0
		let g:BufBufLoadOnlyModeEnable = 0
	else	" full mode
		let g:BufBufListMoveMode = 0
		let g:BufBufShowUnloadMark = 1
		let g:BufBufLoadOnlyModeEnable = 1
	endif
endfunction


function!  BufBufSetModeShowNameless(iFlag)
	if a:iFlag == 0
		let g:BufBufShowNamelessBuf = 0
	else
		let g:BufBufShowNamelessBuf = 1
	endif
endfunction


function!  BufBufSetVerticalWindowWidth(iWidth)
	if a:iWidth > 0
		let g:BufBufVerWindowWidth = a:iWidth
	endif
endfunction


function!  BufBufSetFileNameLength(iLength)
	if a:iLength > 0
		let g:BufBufFileNameLength = a:iLength
	endif
endfunction


function!  BufBufSetNoMassageBuffer(iFlag)
	if a:iFlag != 0
		let g:BufBufEmptyMsg0 = ""
		let g:BufBufEmptyMsg1 = ""
	else
		let g:BufBufEmptyMsg0 = "No buffer listed.\n"
		let g:BufBufEmptyMsg1 = "This buffer is unloaded.\n\tType 'l' to load.\n\tType 'x' to unload."
	endif
endfunction



"-----------launcher--------------------
"
" launch the BUFBUF buffer list
function!  BufBufLauncher(iMode)
	if BufBufIsTmpBufferActive() || a:iMode == 0
		call BufBufWindowClose()
		return
	elseif a:iMode > 2
		return
	endif

	" when first launched
	if g:BufBufFirst
		call BufBufSetLoadOnlyMode(g:BufBufLoadOnlyInit)
		let g:BufBufFirst = 0
	endif

	let g:BufBufCurDir = getcwd()
	let g:BufBufLastBufId = bufnr('')
	call BufBufListIdListUpdate()
	call BufBufSetSelectFromBufId(bufnr(''))
	call BufBufWindowOpen(a:iMode)
	call BufBufListView()
endfunction



function!  BufBufSetLoadOnlyMode(iMode)
	let g:BufBufLoadOnly = a:iMode
	if a:iMode == 1
		let g:BufBufCurIdList = g:BufBufIdListLoadOnly
		let g:BufBufAnotherIdList = g:BufBufIdList
	else
		let g:BufBufCurIdList = g:BufBufIdList
		let g:BufBufAnotherIdList = g:BufBufIdListLoadOnly
	endif
endfunction



function!  BufBufChangeLoadOnlyMode()
	if g:BufBufLoadOnlyModeEnable == 0
		return
	endif

	" change mode and select the buffer
	let l:iLastModeListSize = BufBufIdListSize()
	if g:BufBufLoadOnly
		" reflect order changes from g:BufBufIdListLoadOnly to g:BufBufIdList
		let l:iI = 0
		let l:iJ = 0
		while l:iI < len(g:BufBufIdList)
			if bufloaded(g:BufBufIdList[l:iI])
				if l:iJ >= len(g:BufBufIdListLoadOnly)
					echo "BufBufChangeLoadOnlyMode : unknown error! but safe..."
				else
					let g:BufBufIdList[l:iI] = g:BufBufIdListLoadOnly[l:iJ]
					let l:iJ += 1
				endif
			endif
			let l:iI += 1
		endwhile

		call BufBufSetLoadOnlyMode(0)
	else
		" search loaded buffer forward
		let l:i = BufBufSelectLine() - 1
		while 0 <= l:i && l:i < l:iLastModeListSize
			if bufloaded(g:BufBufIdList[l:i])
				break
			endif
			let l:i += 1
		endwhile

		" search loaded buffer backward
		if l:i >= l:iLastModeListSize
			let l:i = BufBufSelectLine() - 1
			while 0 <= l:i && l:i < l:iLastModeListSize
				if bufloaded(g:BufBufIdList[l:i])
					break
				endif
				let l:i -= 1
			endwhile
		endif

		if l:i != -1
			call BufBufSetSelectFromLine(l:i+1)
			call BufBufBufferShow()
		endif
		call BufBufSetLoadOnlyMode(1)
	endif

	call BufBufListIdListUpdate()
	call BufBufWindowFocusTarget()
	call BufBufSetSelectFromBufId(bufnr(''))
	call BufBufWindowFocus()
	call BufBufSetSelectSelfCheck()	" for safe
	call BufBufListView()
endfunction



"-----------window control------------
" 
" split in horizontal for list window
function!  BufBufWindowOpen(iMode)
	if !bufexists(g:BufBufTmpBufId) || !bufexists(g:BufBufEmptyBufId)
		if a:iMode == 1
			exec 'silent! ' . BufBufIdListSize() . 'new ' . g:BufBufEmptyBufName
		elseif a:iMode == 2
			exec 'silent! ' . g:BufBufVerWindowWidth . 'vne ' . g:BufBufEmptyBufName
		endif
		let g:BufBufEmptyBufId = bufnr('')
		call BufBufWindowEmptySetting()
		exec 'silent! e ' . g:BufBufTmpBufName
		call BufBufWindowSetting()
		let g:BufBufTmpBufId = bufnr('')
	else
		if a:iMode == 1
			exec 'silent! ' . BufBufIdListSize() . 'sp '
		elseif a:iMode == 2
			exec 'silent! ' . g:BufBufVerWindowWidth . 'vsp '
		endif
		exec 'silent! b ' . g:BufBufTmpBufName
	endif

	let g:BufBufListWinId = winnr()
	let g:BufBufTargetWinId = winnr('#')
	let g:BufBufMode = a:iMode " save mode
	echo ""
endfunction



" resize window
function!  BufBufWindowResize()
	if g:BufBufMode == 1
		call cursor(1, 1)
		exec 'silent resize ' . BufBufIdListSize()
	endif
	if g:BufBufLoadOnly
		exec 'setlocal statusline=' . BufBufIdListSize() . '\ loaded'
	else
		exec 'setlocal statusline=' . BufBufIdListSize() . '\ listed'
	endif
	call cursor(BufBufSelectLine(), 1)
endfunction
	


" close list window
function!  BufBufWindowClose()
	if bufexists(g:BufBufTmpBufId)
		let g:BufBufMode = 0 " set mode
		if bufnr('') == g:BufBufTmpBufId
			exec 'silent! q!'
		else
			exec 'silent! bun! ' . g:BufBufTmpBufId
		endif
	endif
endfunction



" quit to select and close window
" non-recommended and no support
function!  BufBufWindowQuit()
	let l:iLastLine = BufBufLineFromId(g:BufBufLastBufId)
	if l:iLastLine != 0
		call BufBufListMoveTo(l:iLastLine)
		call BufBufBufferShowEnterClose()
	else
		call BufBufWindowClose()
	endif
endfunction



" set local param of list window
function!  BufBufWindowSetting()
	setlocal modifiable
	setlocal nonumber
	setlocal nobuflisted
	setlocal buftype=nofile
	setlocal noswapfile
	setlocal bufhidden=unload
	setlocal noshowcmd
	setlocal nowrap
	setlocal nolist

"	command -buffer -count=0 BufBufGoto :call BufBufListMoveTo(<count>)
	command -buffer -count=0 BufBufCmdG :call BufBufListMoveWrapForCmd(<count>,"G")
	command -buffer -count=0 BufBufCmdj :call BufBufListMoveWrapForCmd(<count>,"j")
	command -buffer -count=0 BufBufCmdk :call BufBufListMoveWrapForCmd(<count>,"k")
	command -buffer -count=0 BufBufCmdSj :call BufBufListMoveWrapForCmd(<count>,"S-j")
	command -buffer -count=0 BufBufCmdSk :call BufBufListMoveWrapForCmd(<count>,"S-k")

	noremap <silent> <buffer> j :BufBufCmdj<CR>
	noremap <silent> <buffer> k :BufBufCmdk<CR>
	noremap <silent> <buffer> l :call BufBufBufferShow()<CR>
	map <silent> <buffer> <Down> j
	map <silent> <buffer> <Up> k
	map <silent> <buffer> <Right> l
	noremap <silent> <buffer> <S-j> :BufBufCmdSj<CR>
	noremap <silent> <buffer> <S-k> :BufBufCmdSk<CR>
	map <silent> <buffer> <S-l> l
	noremap <silent> <buffer> r :call BufBufListMoveTo(-1)<CR>
	nnoremap <silent> <buffer> G :BufBufCmdG<CR>
	nnoremap <silent> <buffer> goto :BufBufCmdG<CR>
	map <silent> <buffer> gg 1G
	noremap <silent> <buffer> q <Esc>:call BufBufWindowClose()<CR>
	noremap <silent> <buffer> c <Esc>:call BufBufWindowClose()<CR>
	noremap <silent> <buffer> <Esc> <Esc>:call BufBufWindowClose()<CR>
	noremap <silent> <buffer> o <Esc>:call BufBufBufferShowEnterClose()<CR>
	noremap <silent> <buffer> <CR> <Esc>:call BufBufBufferShowEnterClose()<CR>
	noremap <silent> <buffer> d :call BufBufBufferRemove('bd')<CR>
	noremap <silent> <buffer> !d :call BufBufBufferRemove('bd!')<CR>
	noremap <silent> <buffer> w :call BufBufBufferRemove('bw')<CR>
	noremap <silent> <buffer> !w :call BufBufBufferRemove('bw!')<CR>
	noremap <silent> <buffer> x :call BufBufBufferRemove('bun')<CR>
	noremap <silent> <buffer> !x :call BufBufBufferRemove('bun!')<CR>
	noremap <silent> <buffer> <space> <Esc>:call BufBufListMoveOutUnloadedBuffer()<CR>
	noremap <silent> <buffer> <S-space> <Esc>:call BufBufChangeLoadOnlyMode()<CR>

	noremap <silent> <buffer> <LeftRelease> :call BufBufMouseAction("LEFT_RELEASE")<CR>
	noremap <silent> <buffer> <2-LeftMouse> <Esc>:call BufBufMouseAction("DOUBLE_CLICK")<CR>
	noremap <silent> <buffer> <LeftDrag> <Nop>

	noremap <silent> <buffer> <C-o> <Nop>
	noremap <silent> <buffer> : <Nop>

	au BufWinLeave <buffer> call BufBufWindowClose()

	setlocal nomodifiable
endfunction



" set local param of empty window
function!  BufBufWindowEmptySetting()
	setlocal modifiable
	setlocal nonumber
	setlocal nobuflisted
	setlocal buftype=nofile
	setlocal noswapfile
	setlocal bufhidden=
	setlocal noshowcmd
	setlocal nowrap
	setlocal nolist
	setlocal nomodifiable
endfunction



" focus the list window
function!  BufBufWindowFocus()
	exec bufwinnr(g:BufBufTmpBufId) . 'wincmd w'
	exec "silent cd " . g:BufBufCurDir . ""
endfunction



" focus the target window
function!  BufBufWindowFocusTarget()
	if !BufBufIsTmpBufferActive()
		return
	endif

	call BufBufWindowFocus()

	" if number of window is 1, reconstruct windows
	if winnr('$') == 1
		call BufBufWindowOpen(g:BufBufMode)
		call BufBufListIdListUpdate()
		call BufBufListView()
	endif

	" try to believe the difference between target win id and list win id
	let g:BufBufTargetWinId = winnr() + (g:BufBufTargetWinId - g:BufBufListWinId)
	let g:BufBufListWinId = winnr()

	if g:BufBufTargetWinId < 1
		exec '1wincmd w'
		exec 'sp '
		let g:BufBufTargetWinId = 1
	elseif g:BufBufTargetWinId > winnr('$')
		exec winnr('$') . 'wincmd w'
		exec 'sp '
		let g:BufBufTargetWinId = winnr('$')
	else
	endif

	exec g:BufBufTargetWinId . 'wincmd w'

	echo ""
endfunction



"-----------mouse action-----------------
"
" 
function!  BufBufMouseAction(sAction)
	if !BufBufIsTmpBufferActive()
		" unknown case, quit the BUFBUF list
		call BufBufWindowClose()
		return
	endif

	if a:sAction == "LEFT_RELEASE"
		call BufBufListMoveTo(line('.'))
		call BufBufBufferShow()
	elseif a:sAction == "DOUBLE_CLICK"
		call BufBufListMoveTo(line('.'))
		call BufBufBufferShowEnterClose()
	endif
endfunction



"-----------list control------------
"
" view list fully
" need to call BufBufListIdListUpdate before exec this function
function!  BufBufListView()
	call BufBufWindowFocus()
	call BufBufWindowResize()
	call BufBufListDump()
	call cursor(BufBufSelectLine(), 1)
endfunction


 
" update the viewing line corresponding to the specified buffer
function!  BufBufListViewUpdateLineFromBufId(iBufId)
	" check this buffer is BUFBUF tmp buffer
	if bufnr('') != g:BufBufTmpBufId
		echo "BufBufListViewUpdateLineFromBufId : cancelled"
		return
	endif

	let l:iLine = BufBufLineFromId(a:iBufId)
	if l:iLine == 0
		return
	endif
	let l:sItem = BufBufListItemFormat(a:iBufId)
	call BufBufRegEscape()
	setlocal modifiable
  	exec 'silent ' . l:iLine . ' d'
	put! =l:sItem
	setlocal nomodifiable
	call BufBufRegRestore()

	call cursor(BufBufSelectLine(), 1)
endfunction



" update the viewing line corresponding to the specified lines
function!  BufBufListViewUpdateLineFromLine(LineList)
	" check this buffer is BUFBUF tmp buffer
	if bufnr('') != g:BufBufTmpBufId
		echo "BufBufListViewUpdateLineFromBufId : cancelled"
		return
	endif

	call BufBufRegEscape()
	setlocal modifiable
	for l:iLine in a:LineList
	  	exec 'silent ' . l:iLine . ' d'
		let l:iBufId = BufBufIdFromLine(l:iLine)
		put! =BufBufListItemFormat(l:iBufId)
	endfor
	setlocal nomodifiable
	call BufBufRegRestore()

	call cursor(BufBufSelectLine(), 1)
endfunction



" remove the viewing line corresponding to the specified buffer id
" this function must be called after really removing the buffer
function!  BufBufListViewRemoveLineFromLine(iLine)

	" check this buffer is BUFBUF tmp buffer
	if bufnr('') != g:BufBufTmpBufId
		echo "BufBufListViewRemoveBufId : cancelled"
		return
	endif

	call BufBufWindowFocus()
	call BufBufRegEscape()
	setlocal modifiable
	exec 'silent ' . a:iLine . ' d'
	setlocal nomodifiable
	call BufBufRegRestore()

	call BufBufWindowResize()

	if a:iLine < BufBufSelectLine()
		call BufBufSetSelectFromLine( BufBufSelectLine() - 1 )
	endif

	call cursor(BufBufSelectLine(), 1)
endfunction



" update buffer list
function!  BufBufListIdListUpdate()
	let l:sLsResult = ""
	let l:sLsResultList = []
	let l:iCurrentBufnr = bufnr('')
	let l:ListSize = 0
	let l:NowIdList = []
	let l:sTmp = ""

	" get the current buffer list
	redir => l:sLsResult | silent! ls | redir END
	let l:sLsResultList = split(l:sLsResult,"\n")
	for l:sLsItem in l:sLsResultList
		let l:sTmp = (split(sLsItem,' '))[0]
		let l:sTmp = (split(sTmp,'u'))[0]
		let l:iBufId = str2nr(l:sTmp)
		let l:iBufName = bufname(l:iBufId)
		if l:iBufName == g:BufBufTmpBufName || l:iBufName == g:BufBufEmptyBufName
			continue
		endif
		if g:BufBufShowNamelessBuf
			call add(l:NowIdList, l:iBufId)
		else
			if strlen(l:iBufName) != 0
				call add(l:NowIdList, l:iBufId)
			endif
		endif
	endfor

	" update g:BufBufIdList from the current buffer list(l:NowIdList)
	let l:i = 0
	while l:i < len(l:NowIdList)
		if index(g:BufBufIdList, l:NowIdList[l:i]) == -1
			call add(g:BufBufIdList, l:NowIdList[l:i])
		endif
		let l:i += 1
	endwhile
	let l:i = len(g:BufBufIdList) - 1
	while l:i >= 0
		if index(l:NowIdList, g:BufBufIdList[l:i]) == -1
			call remove(g:BufBufIdList,l:i)
		endif
		let l:i -= 1
	endwhile

	" reset g:BufBufLoadIdList
	if len(g:BufBufIdListLoadOnly) != 0
		call remove(g:BufBufIdListLoadOnly,0,-1)
	endif
	for l:iBufId in g:BufBufIdList
		if bufloaded(l:iBufId)
			call add(g:BufBufIdListLoadOnly, l:iBufId)
		endif
	endfor
endfunction



" dump list items to list window 
function!  BufBufListDump()
	" check this buffer is BUFBUF tmp buffer
	if bufnr('') != g:BufBufTmpBufId
		echo "BufBufListDump : cancelled"
		return
	endif

	" delete all
	let l:EndLine = line('$')
	call BufBufRegEscape()
	setlocal modifiable
  	exec 'silent 1,' . l:EndLine . ' d'
	setlocal nomodifiable
	call BufBufRegRestore()

	" make list of buffer name and list of buffer name length
	let l:sItemList = []
	for l:iBufId in g:BufBufCurIdList
		let l:sItem = BufBufListItemFormat(l:iBufId)
		call add(l:sItemList, l:sItem)
	endfor

	let l:sJoin = join(l:sItemList,"\n")
	setlocal modifiable
	silent put! =l:sJoin
	setlocal nomodifiable
endfunction



" define the format of a list item
function!  BufBufListItemFormat( iBufId )
	exec "silent cd " . g:BufBufCurDir . ""
	let l:sBufName = bufname(a:iBufId)
	let l:sItem = ""
	if strlen(l:sBufName) == 0
		let l:sItem = g:BufBufNameless
	else
		let l:sFileName = fnamemodify(l:sBufName,":t")
		let l:sDirName = fnamemodify(l:sBufName,":h")
	
		while strlen(l:sFileName) < g:BufBufFileNameLength
			let l:sFileName = l:sFileName . ' '
		endwhile

		if strlen(l:sFileName) > g:BufBufFileNameLength
			let l:sFileName = strpart(l:sFileName,0,g:BufBufFileNameLength)
		endif

		let l:sItem = l:sFileName . ' ' . l:sDirName
	endif

	" reduce indent if selected
	if a:iBufId == BufBufSelectBufId()
	else
		let l:sItem = ' ' . l:sItem
	endif

	" add '+' if modified
	if getbufvar(a:iBufId, '&modified')
		let l:sItem = '+' . l:sItem
	else
		let l:sItem = ' ' . l:sItem
	endif

	if g:BufBufShowUnloadMark
		" show 'x' if unloaded
		if !bufloaded(a:iBufId)
			let l:sItem = 'x' . strpart(l:sItem,1)
		endif
	endif

	" add '*' if displayed in windows of a window
	if bufwinnr(a:iBufId) != -1
		let l:sItem = '*' . l:sItem
	else
		let l:sItem = ' ' . l:sItem
	endif

	" add '@' if the last buffer
	if a:iBufId == g:BufBufLastBufId
		let l:sItem = '@' . strpart(l:sItem,1)
	else
	endif

	" add '>' if selected
	if a:iBufId == BufBufSelectBufId()
		let l:sItem = '> ' . l:sItem
	else
		let l:sItem = '  ' . l:sItem
	endif

	return l:sItem
endfunction



" calc target line number from <count> and command
function! BufBufListMoveWrapForCmd(iCount, iCmd)
	let l:iLine = 0
	if a:iCmd == "G"
		if a:iCount == 0
			let l:iLine = BufBufIdListSize()
		else
			let l:iLine = a:iCount - line(".") + 1
		endif
	elseif a:iCmd == "j" || a:iCmd == "S-j"
		if a:iCount == 0
			let l:iLine = line(".") + 1
		else
			let l:iLine = a:iCount + 1
		endif
	elseif a:iCmd == "k" || a:iCmd == "S-k"
		if a:iCount == 0
			let l:iLine = line(".") - 1
		else
			let l:iLine = 2*line(".") - a:iCount - 1
		endif
	endif

	if a:iCmd[0] == "S"
		call BufBufListMoveItemTo(l:iLine)
	else
		call BufBufListMoveTo(l:iLine)
	endif
endfunction



" move cursor and show buffer if loaded
function! BufBufListMoveTo(iLine)
	if BufBufIdListSize() == 0
		return
	endif

	call BufBufListCursorTo(a:iLine)

	if g:BufBufListMoveMode == 0
		if bufloaded(BufBufSelectBufId())
			call BufBufBufferShow()
		else
			call BufBufBufferShowEmpty(g:BufBufEmptyMsg1)
		endif
	elseif g:BufBufListMoveMode == 1
		call BufBufBufferShow()
	else
	endif

endfunction



" move cursor ( with '>' ) to the specified line
function!  BufBufListCursorTo(iLine)
	if bufnr('') != g:BufBufTmpBufId
		return
	endif

	if BufBufIdListSize() == 0
		return
	endif

	if a:iLine == -1
		call BufBufSetSelectFromBufId(g:BufBufLastBufId)
	else
		call BufBufSetSelectFromLine(a:iLine)
	endif
	call BufBufListViewUpdateLineFromBufId(BufBufSelectLastBufId())
	call BufBufListViewUpdateLineFromBufId(BufBufSelectBufId())
endfunction



" move the selected line to iDstLine
function!  BufBufListMoveItemTo(iDstLine)
	if BufBufIdListSize() == 0
		return
	endif

	let l:iTargetLine = a:iDstLine
	if l:iTargetLine < 1
		let l:iTargetLine = 1
	elseif l:iTargetLine > BufBufIdListSize()
		let l:iTargetLine = BufBufIdListSize()
	endif

	" remove select line and insert it to the target line
	let l:iSelBufId = BufBufSelectBufId()
	let l:iSelLine = BufBufSelectLine()
	if 1 <= l:iSelLine && l:iSelLine <= BufBufIdListSize()
		call remove(g:BufBufCurIdList, l:iSelLine-1)
		call insert(g:BufBufCurIdList, l:iSelBufId, l:iTargetLine-1)
	endif

	if l:iTargetLine < l:iSelLine
		let l:LineList = range(l:iTargetLine, l:iSelLine)
	else
		let l:LineList = range(l:iSelLine, l:iTargetLine)
	endif

	call BufBufSetSelectFromBufId(BufBufSelectBufId())
	call BufBufListViewUpdateLineFromLine(l:LineList)
endfunction



" move out the unloaded buffers in upward or downward
function!  BufBufListMoveOutUnloadedBuffer()
	if g:BufBufLoadOnly || BufBufIdListSize() == 0 
				\ || g:BufBufLoadOnlyModeEnable == 0
		return
	endif

	" remove select line and insert it to the target line
	let l:UnloadIdList = []
	let l:i = BufBufIdListSize() - 1
	while l:i >= 0
		if !bufloaded(g:BufBufCurIdList[l:i])
			call add( l:UnloadIdList, remove(g:BufBufCurIdList, l:i) )
		endif
		let l:i -= 1
	endwhile

	call reverse(l:UnloadIdList)

	if g:BufBufMoveOutDirection == 1
		call extend(g:BufBufCurIdList, l:UnloadIdList, 0)
	else
		call extend(g:BufBufCurIdList, l:UnloadIdList)
	endif

	call BufBufSetSelectFromBufId(BufBufSelectBufId())
	call BufBufListView()
endfunction




"-----------buffer control------------
" 
" show the selected buffer to the target window
function!  BufBufBufferShow()
	if BufBufIdListSize() == 0
		return
	endif

	call BufBufWindowFocusTarget()
	let l:LoadedBufId = bufnr('')
	exec 'silent! b ' . BufBufSelectBufId()
"	call BufBufSetSelectFromBufId(bufnr(''))	" for safe
	call BufBufWindowFocus()

	call BufBufListViewUpdateLineFromBufId(l:LoadedBufId)
	call BufBufListViewUpdateLineFromBufId(BufBufSelectBufId())
endfunction



" load and show the selected buffer and enter the target window
function!  BufBufBufferShowEnter()
	call BufBufBufferShow()
	call BufBufWindowFocusTarget()
endfunction



" focus the target window and close BUFBUF window, and load the buffer
function!  BufBufBufferShowEnterClose()
	call BufBufWindowFocusTarget()
	call BufBufWindowClose()
	exec 'silent! b ' . BufBufSelectBufId()
endfunction



" show BUFBUF empty buffer to the target window
function!  BufBufBufferShowEmpty(sMessage)
	if BufBufIdListSize() == 0
		return
	endif

	call BufBufWindowFocusTarget()
	let l:LoadedBufId = bufnr('')
	exec 'silent! b ' . g:BufBufEmptyBufId

	if bufnr('') != g:BufBufEmptyBufId
		echo "BufBufBufferShowEmpty : cancelled"
		return
	endif

	if g:BufBufEmptyMessageLast != a:sMessage
		call BufBufRegEscape()
		setlocal modifiable
		let l:EndLine = line('$')
  		exec 'silent 1,' . l:EndLine . ' d'
		silent put! =a:sMessage
		call cursor(1,1)
		setlocal nomodifiable
		call BufBufRegRestore()
	endif

	call BufBufWindowFocus()
	call BufBufListViewUpdateLineFromBufId(l:LoadedBufId)
	let g:BufBufEmptyMessageLast = a:sMessage
endfunction



" delete, wipeout and unload the selected buffer
function!  BufBufBufferRemove(sCmd)
	if !BufBufIsTmpBufferActive()
		return
	endif

	call BufBufWindowFocus()

	if BufBufIdListSize() == 0
		return
	endif

	" if buffer modified
	if getbufvar(BufBufSelectBufId(), '&modified')
		if a:sCmd[strlen(a:sCmd)-1] != '!'
			echo "This buffer is modified. Type '!' \"before\" command to recursively exec."
			return
		else 
			echo ""
		endif
	endif

	let l:iTargetBufId = BufBufSelectBufId()
	let l:iTargetLine = BufBufSelectLine()
	let l:sCmdTwoChar = strpart(a:sCmd,0,2)
	if ( l:sCmdTwoChar == "bd" ) || ( l:sCmdTwoChar == "bw" )
			\ || ( l:sCmdTwoChar == "bu" &&  strlen(bufname(l:iTargetBufId)) == 0 )
			\ || ( l:sCmdTwoChar == "bu" &&  g:BufBufLoadOnly )
		if BufBufIdListSize() == 1
			call BufBufBufferShowEmpty(g:BufBufEmptyMsg0)
		elseif BufBufSelectLine() < BufBufIdListSize()
			call BufBufListMoveTo(l:iTargetLine+1)
		else
			call BufBufListMoveTo(l:iTargetLine-1)
		endif
		exec a:sCmd . ' ' . l:iTargetBufId
	else  " expecting a:sCmd == "bun"
		if bufloaded(BufBufSelectBufId())
			call BufBufBufferShowEmpty(g:BufBufEmptyMsg1)
			exec a:sCmd . ' ' . l:iTargetBufId
		endif
	endif

	let l:iListSize = BufBufIdListSize()
	call BufBufListIdListUpdate()
	if BufBufIdListSize() == l:iListSize
		call BufBufListViewUpdateLineFromBufId(l:iTargetBufId)
	elseif BufBufIdListSize() == l:iListSize - 1
		call BufBufListViewRemoveLineFromLine(l:iTargetLine)
	endif

endfunction



"-----------others--------------------
"
"
let g:iBufBufSelectBufId = 0
let g:iBufBufSelectLine = 0
let g:iBufBufSelectLineLoadOnly = 0
let g:iBufBufSelectLastBufId = 0
let g:iBufBufSelectLastLine = 0
let g:iBufBufSelectLastLineLoadOnly = 0


" set select buffer and line from buffer id
function!  BufBufSetSelectFromBufId(iBufId)
	let l:iLine = index(g:BufBufIdList, a:iBufId) + 1
	if iLine != 0
		let g:iBufBufSelectLastBufId = g:iBufBufSelectBufId
		let g:iBufBufSelectLastLine = g:iBufBufSelectLine
		let g:iBufBufSelectBufId = a:iBufId
		let g:iBufBufSelectLine = l:iLine
	endif

	let l:iLine = index(g:BufBufIdListLoadOnly, a:iBufId) + 1
	if iLine != 0
		let g:iBufBufSelectLastLineLoadOnly = g:iBufBufSelectLineLoadOnly
		let g:iBufBufSelectLineLoadOnly = l:iLine
	endif
endfunction


" set select buffer and line from line
function!  BufBufSetSelectFromLine(iLine)
	call BufBufSetSelectFromBufId(BufBufIdFromLine(a:iLine))
endfunction


" self consistency check selected buffer id and line
function!  BufBufSetSelectSelfCheck()
	let l:iSelId = BufBufSelectBufId()
	let l:iSelLine = BufBufSelectLine()

	let l:iLine = index(g:BufBufCurIdList, l:iSelId) + 1

	if l:iLine == 0 " select bufid doesnt exist in idlist
		if 1 <= l:iSelLine && l:iSelLine <= BufBufIdListSize()
			" if line can be believed
			let g:iBufBufSelectBufId = g:BufBufCurIdList[l:iSelLine-1]
		else
			let g:iBufBufSelectLine = 1
			if BufBufIdListSize() == 0
				let g:iBufBufSelectBufId = 0
			else
				let g:iBufBufSelectBufId = g:BufBufCurIdList[1]
			endif
		endif
	else
		if g:BufBufLoadOnly
			let g:iBufBufSelectLineLoadOnly = l:iLine
		else
			let g:iBufBufSelectLine = l:iLine
		endif
	endif
endfunction


function!  BufBufIdFromLine(iLine)
	if BufBufIdListSize() == 0
		return 0
	endif

	let l:iSelLine = a:iLine
	if a:iLine < 1
		let l:iSelLine = 1
	elseif a:iLine > BufBufIdListSize()
		let l:iSelLine = BufBufIdListSize()
	endif

	return g:BufBufCurIdList[l:iSelLine-1]
endfunction


function!  BufBufLineFromId(iBufId)
	return index(g:BufBufCurIdList, a:iBufId) + 1
endfunction


function!  BufBufSelectBufId()
	return g:iBufBufSelectBufId
endfunction


function!  BufBufSelectLastBufId()
	return g:iBufBufSelectLastBufId
endfunction


function!  BufBufSelectLine()
	if g:BufBufLoadOnly
		return g:iBufBufSelectLineLoadOnly
	else
		return g:iBufBufSelectLine
	endif
endfunction


function!  BufBufSelectLastLine()
	if g:BufBufLoadOnly
		return g:iBufBufSelectLastLineLoadOnly
	else
		return g:iBufBufSelectLastLine
	endif
endfunction


function!  BufBufIdListSize()
	return len(g:BufBufCurIdList)
endfunction



" current buffer is or isn't BUFBUF tempolary buffer
function!  BufBufIsTmpBufferActive()
	if bufwinnr(g:BufBufTmpBufId) == -1
		return 0
	else
		return 1
	endif
endfunction


" escape the registar contents to tempolary variable
function!  BufBufRegEscape()
	let g:BufBufRegEscapeTmp = [ @0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @", @* ] 
endfunction


" restore the registar contents from tempolary variable
function!  BufBufRegRestore()
	let @0 = g:BufBufRegEscapeTmp[0]
	let @1 = g:BufBufRegEscapeTmp[1]
	let @2 = g:BufBufRegEscapeTmp[2]
	let @3 = g:BufBufRegEscapeTmp[3]
	let @4 = g:BufBufRegEscapeTmp[4]
	let @5 = g:BufBufRegEscapeTmp[5]
	let @6 = g:BufBufRegEscapeTmp[6]
	let @7 = g:BufBufRegEscapeTmp[7]
	let @8 = g:BufBufRegEscapeTmp[8]
	let @9 = g:BufBufRegEscapeTmp[9]
	let @" = g:BufBufRegEscapeTmp[10]
	let @* = g:BufBufRegEscapeTmp[11]
endfunction

