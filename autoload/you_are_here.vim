let g:youarehere_border = [1, 1, 1, 1]
let g:youarehere_padding = [1, 1, 1, 1]
let s:youarehere_is_open = 0
let g:content = "%"

highlight default link YouAreHereText Pmenu
highlight default link YouAreHereBorder Pmenu
highlight default link YouAreHereScrollbar PmenuSbar
highlight default link YouAreHereThumb PmenuThumb

highlight default link YouAreHereActiveText YouAreHereText
highlight default link YouAreHereActiveBorder PmenuSel
highlight default link YouAreHereActiveScrollbar YouAreHereScrollbar
highlight default link YouAreHereActiveThumb YouAreHereThumb

function! s:WindowCoords(n)
  return [
        \winheight(a:n) / 2,
        \winwidth(a:n) / 2
        \]
endfunction

function! s:GetContent()
  return expand(g:content)
endfunction

function! s:GetPopupDimensions()
  let l:width = winwidth(0) - g:youarehere_border[1] - g:youarehere_border[3] - g:youarehere_padding[1] - g:youarehere_padding[3] - 2
  let l:height = winheight(0) - g:youarehere_border[0] - g:youarehere_border[2] - g:youarehere_padding[0] - g:youarehere_padding[2] - 2
  let l:content = <SID>GetContent()
  let l:content_length = strlen(l:content)
  let l:max_width_wider = l:width > l:content_length
  if l:max_width_wider
    let l:wider_x = l:content_length
  else
    let l:wider_x = l:width
  endif
  let l:box_offset_x = l:wider_x / 2 + 1
  let l:box_offset_y = (g:youarehere_border[0] + g:youarehere_border[2] + g:youarehere_padding[0] + g:youarehere_padding[2]) / 2
  let l:window_coords = <SID>WindowCoords(0)
  let l:window_pos = win_screenpos(0)
  let l:popup_coords = [
        \l:window_pos[0] + l:window_coords[0] - l:box_offset_y,
        \l:window_pos[1] + l:window_coords[1] - l:box_offset_x
        \]
  return #{
        \  coords: l:popup_coords,
        \  maxwidth: l:width,
        \  maxheight: l:height
        \}
endfunction

imap <buffer> <silent> <expr> <F12> Double("\<F12>")

function! ClosePopups()
  call popup_clear()
  let s:youarehere_is_open = 0
endfunction

function! s:OpenPopup(win_num)
  let l:is_active = a:win_num == winnr()
  let l:highlight_qualifier = l:is_active ? "Active" : ""
  let l:content = <SID>GetContent()
  let l:popup_dimensions = <SID>GetPopupDimensions()
  let l:popup_coords = l:popup_dimensions.coords
  let l:popup_maxwidth = l:popup_dimensions.maxwidth
  call popup_create(
        \"[" . winnr() . "] " . l:content,
        \#{
        \  line: l:popup_coords[0],
        \  col: l:popup_coords[1],
        \  padding: g:youarehere_padding,
        \  border: g:youarehere_border,
        \  maxwidth: l:popup_maxwidth,
        \  highlight: 'YouAreHere' . l:highlight_qualifier . 'Text',
        \  borderhighlight: ['YouAreHere' . l:highlight_qualifier . 'Border'],
        \  scrollbarhighlight: 'YouAreHere' . l:highlight_qualifier . 'Scrollbar',
        \  thumbhighlight: 'YouAreHere' . l:highlight_qualifier . 'Thumb'
        \}
        \)
endfunction

nnoremap <silent> <ESC> :call ClosePopups()<CR>

" Windo / Windofast
" credit: https://vim.fandom.com/wiki/Windo_and_restore_current_window

" Just like windo, but restore the current window when done.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
com! -nargs=+ -complete=command Windo call WinDo(<q-args>)

" Just like Windo, but disable all autocommands for super fast processing.
com! -nargs=+ -complete=command Windofast noautocmd call WinDo(<q-args>)

function! you_are_here#YouAreHere()
  if s:youarehere_is_open
    call ClosePopups()
    return
  endif
  let s:win_num = winnr()
  Windofast call <SID>OpenPopup(s:win_num)
  let s:youarehere_is_open = 1
endfunction
