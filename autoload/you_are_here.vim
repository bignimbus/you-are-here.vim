if !exists('g:youarehere_border')
  let g:youarehere_border = [1, 1, 1, 1]
endif

if !exists('g:youarehere_padding')
  let g:youarehere_padding = [1, 1, 1, 1]
endif

if !exists('g:youarehere_content')
  let g:youarehere_content = "%"
endif

if !exists('g:youarehere_enable_switch_window_mappings')
  let g:youarehere_enable_switch_window_mappings = 1
endif

if !exists('g:youarehere_enable_switch_window_mappings')
  let g:youarehere_enable_switch_window_mappings = 1
endif

if !exists('g:youarehere_switch_window_mapping_prefix')
  let g:youarehere_switch_window_mapping_prefix = "m"
endif

let s:active_win_num = -1
let s:youarehere_popups = []

highlight default link YouAreHereText Pmenu
highlight default link YouAreHereBorder Pmenu
highlight default link YouAreHereScrollbar PmenuSbar
highlight default link YouAreHereThumb PmenuThumb

highlight default link YouAreHereActiveText YouAreHereText
highlight default link YouAreHereActiveBorder PmenuSel
highlight default link YouAreHereActiveScrollbar YouAreHereScrollbar
highlight default link YouAreHereActiveThumb YouAreHereThumb

function! s:ResetPopups()
  let s:youarehere_popups = []
endfunction

function! s:IsOpen()
  return len(s:youarehere_popups) > 0
endfunction

function! s:WindowCoords(n)
  return [
        \winheight(a:n) / 2,
        \winwidth(a:n) / 2
        \]
endfunction

function! s:GetContent()
  return expand(g:youarehere_content)
endfunction

function! s:GetPopupParams(win_num)
  let l:width = winwidth(a:win_num) - g:youarehere_border[1] - g:youarehere_border[3] - g:youarehere_padding[1] - g:youarehere_padding[3] - 2
  let l:height = winheight(a:win_num) - g:youarehere_border[0] - g:youarehere_border[2] - g:youarehere_padding[0] - g:youarehere_padding[2] - 2
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
  let l:window_coords = <SID>WindowCoords(a:win_num)
  let l:window_pos = win_screenpos(a:win_num)
  let l:popup_coords = [
        \l:window_pos[0] + l:window_coords[0] - l:box_offset_y,
        \l:window_pos[1] + l:window_coords[1] - l:box_offset_x
        \]
  return {
        \  'coords': l:popup_coords,
        \  'maxwidth': l:width,
        \  'maxheight': l:height
        \}
endfunction

function! s:GetPopupHighlightParams(win_num)
  let l:is_active = a:win_num == s:active_win_num
  let l:highlight_qualifier = l:is_active ? "Active" : ""
  return {
        \  'highlight': 'YouAreHere' . l:highlight_qualifier . 'Text',
        \  'borderhighlight': ['YouAreHere' . l:highlight_qualifier . 'Border'],
        \  'scrollbarhighlight': 'YouAreHere' . l:highlight_qualifier . 'Scrollbar',
        \  'thumbhighlight': 'YouAreHere' . l:highlight_qualifier . 'Thumb'
        \}
endfunction

function! s:ClosePopups()
  for p in s:youarehere_popups
    call popup_close(p[0])
    execute "nunmap " . g:youarehere_switch_window_mapping_prefix . p[1]
  endfor
  call <SID>ResetPopups()

  call timer_stop(s:timeout)
endfunction

function! s:GetPopupOptions(win_num)
  let l:popup_params = <SID>GetPopupParams(a:win_num)
  let l:popup_highlight_params = <SID>GetPopupHighlightParams(a:win_num)
  let l:popup_coords = l:popup_params.coords
  let l:popup_maxwidth = l:popup_params.maxwidth
  return {
        \  'line': l:popup_coords[0],
        \  'col': l:popup_coords[1],
        \  'padding': g:youarehere_padding,
        \  'border': g:youarehere_border,
        \  'maxwidth': l:popup_maxwidth,
        \  'highlight': l:popup_highlight_params.highlight,
        \  'borderhighlight': l:popup_highlight_params.borderhighlight,
        \  'scrollbarhighlight': l:popup_highlight_params.scrollbarhighlight,
        \  'thumbhighlight': l:popup_highlight_params.thumbhighlight
        \}
endfunction

function! s:OpenPopup(win_num)
  let l:content = <SID>GetContent()
  let l:popup = popup_create(
        \"[" . winnr() . "] " . l:content,
        \<SID>GetPopupOptions(a:win_num)
        \)
  let s:youarehere_popups = add(s:youarehere_popups, [l:popup, a:win_num])
  execute "nmap <silent> " . g:youarehere_switch_window_mapping_prefix . a:win_num . " :call you_are_here#ChangeWindow(" . a:win_num . ")<CR>"
endfunction

function! s:UpdatePopup(popup)
  let l:id = a:popup[0]
  let l:win_num = a:popup[1]
  let l:opts = <SID>GetPopupOptions(l:win_num)
  call popup_setoptions(
        \l:id,
        \{
        \  'highlight': l:opts.highlight,
        \  'borderhighlight': l:opts.borderhighlight,
        \  'scrollbarhighlight': l:opts.scrollbarhighlight,
        \  'thumbhighlight': l:opts.thumbhighlight,
        \}
        \)
endfunction

" Windo / Windofast
" credit: https://vim.fandom.com/wiki/Windo_and_restore_current_window

" Just like windo, but restore the current window when done.
function! s:WinDo(command)
  let currwin = winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction

function! s:UpdatePopups()
  for p in s:youarehere_popups
    call <SID>UpdatePopup(p)
  endfor
endfunction

function! s:YouAreHere()
  let s:active_win_num = winnr()
  if <SID>IsOpen()
    call <SID>ClosePopups()
    return
  endif
  noautocmd call s:WinDo("call <SID>OpenPopup(winnr())")
endfunction

function! you_are_here#Update()
  let s:active_win_num = winnr()
  call <SID>UpdatePopups()
endfunction

function! you_are_here#Close()
  call <SID>ClosePopups()
endfunction

function! you_are_here#YouAreHere()
  call <SID>YouAreHere()
endfunction

function! you_are_here#Toggle()
  call <SID>YouAreHere()
endfunction

function! you_are_here#ToggleFor(duration)
  call you_are_here#Toggle()

  let s:timeout = timer_start(
    \ a:duration,
    \ {-> you_are_here#Close()}
    \ )
endfunction

function! you_are_here#ChangeWindow(win_num)
  execute a:win_num . "wincmd w"
  call you_are_here#Update()
endfunction
