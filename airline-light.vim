"""" BUFFER TAB CUSTOMIZATION """"

" custom tab bar function to show
" buffers instead of tabs
" ref: http://vimdoc.sourceforge.net/htmldoc/tabpage.html
function! MyTabLine()
  let buflist = filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
  let s = ''
  for i in buflist
    " if current buffer, set to current
    " tab
    if i == bufnr('%')
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " get buffer file name
    let filename = fnamemodify(bufname(i) , ':t')
    if filename == ''
      let filename = '[No Name]'
    endif

    " put file name and buffer number together
    " and concatentate with previous buffers
    let s .= ' ' . i . '. ' . filename . ' '
  endfor

  " reset to main tab fill after buffers
  " are displayed
  let s .= '%#TabLineFill#%T'

  " right-align the buffer text and clock 
  let s .= '%=' . strftime('%k:%M') . ' ' . '%#TabLineEnd#%999X buffers '

  " return completed buffer bar
  return s
endfunction

"""" TAB BAR AND STATUS LINE THEME """"
" Tab and Status Line Theme
" basic theme
function! TabStatusThemeSimple()
  " status line
  let g:statusnormal = 214
  let g:statusvisual = 005
  let g:statusinsert = 039
  let g:statusother = 008
  exe 'hi! StatusLine ctermfg='.g:statusnormal
  hi User1 ctermbg=240
  " buffer tab
  hi TabLineFill cterm=none ctermfg=223 ctermbg=237
  hi TabLine cterm=none ctermfg=223 ctermbg=237
  hi TabLineSel cterm=bold ctermfg=236 ctermbg=214
  hi TabLineEnd cterm=bold ctermfg=0 ctermbg=175
endfunction

"""" Sets up Tab Bar parameters """"
function! InitTabBar()
    " enable tab bar
    set showtabline=2

    " set tab bar
    set tabline=%!MyTabLine()

    " set tab bar theme
    call TabStatusThemeSimple()

    " refresh tab bar to keep time
    " current
    autocmd CursorHold * call Timer()
endfunction

call InitTabBar()

"""" Tab Bar Refresh (for clock) """"
function! Timer()
  call feedkeys("f\e")
  set tabline=%!MyTabLine()              
endfunction


"""" STATUS LINE """"
" Most taken from: https://gabri.me/blog/diy-vim-statusline
" Note that the %1 values in set statusline+= refer to color
" values defined in the theme function. These work as follows:
" User1 -> %1
" User2 -> %2
" etc.
" They must follow this convention, and be called before the
" status bar is configured

"""" MODE DICTIONARY """"
let g:currentmode={
    \ 'n'  : 'NORMAL ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'VISUAL ',
    \ 'V'  : 'V·Line ',
    \ '^V' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'INSERT ',
    \ 'R'  : 'R ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
  \ 't'  : 'TERMINAL '}


"""" CHANGE STATUS COLOR DEPENDING ON MODE """"
" Automatically change the statusline color depending on mode
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermfg='.g:statusnormal
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine ctermfg='.g:statusvisual
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermfg='.g:statusinsert
  else
    exe 'hi! StatusLine ctermfg=006'.g:statusother
  endif
  return ''
endfunction

"""" SPEED UP COLOR CHANGE """"
" custom commands to force quicker color change
vmap <script> <ESC> <ESC><SID>ChangeStatuslineColor
map <script> v v<SID>ChangeStatuslineColor
au InsertLeave * call ChangeStatuslineColor()

" Find out current buffer's size and output it.
function! FileSize()
    let bytes = getfsize(expand('%:p'))
    if (bytes >= 1024)
        let kbytes = bytes / 1024
    endif
    if (exists('kbytes') && kbytes >= 1000)
        let mbytes = kbytes / 1000
    endif

    if bytes <= 0
        return '0'
    endif

    if (exists('mbytes'))
        return mbytes . 'MB '
    elseif (exists('kbytes'))
        return kbytes . 'KB '
    else
        return bytes . 'B '
    endif
endfunction

" Check if current file is read only
function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

" Build status line
set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=%8*\ [%n]                                " buffernr
set statusline+=%8*\ %<%F\ %{ReadOnly()}\ %m\ %w\        " File+path
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%9*\ %=                                  " Space
set statusline+=%9*\ %y\                                 " FileType
set statusline+=%7*\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ " Encoding & Fileformat
set statusline+=%1*\ %-3(%{FileSize()}%)                 " File size
set statusline+=%0*\ %3p%%\ \ %l:\ %3c\                 " Rownumber/total (%)
