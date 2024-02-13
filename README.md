# you-are-here.vim
📌 See the filenames of your vim splits in easy-to-read popups, switch windows seamlessly

![you-are-here.vim screenshot](https://github.com/bignimbus/you-are-here.vim/blob/main/assets/you-are-here.png)

---

This is a small plugin to solve a small problem.
The problem is that having more than a few splits
open can be disorienting for onlookers in pair
programming sessions, demos, or presentations.
Every now and then, you may even find yourself
wanting a quick, readable, at-a-glance overview of
the visible splits on the screen.

The solution is this plugin. A key map activates
a popup centered in each visible split.  Each popup
contains the name of the filename of the split that
contains it.  Some small conveniences are included
to facilitate switching windows by their window
number.  For more information on window numbers,
see `:help winnr` in the vim docs.

## Installation

```vim
" vim-plug example

call plug#begin('~/.vimplugins')

Plug 'bignimbus/you-are-here.vim'

call plug#end()

" Add a map of your choice.  I prefer to  use
" <leader>here.  My leader key is set to the
" backslash (\), so by typing \here in normal
" mode, I activate you-are-here.vim. When I
" am ready to close the popups, I use the same
" mapping.

nnoremap <silent> <leader>here :call you_are_here#Toggle()<CR>

" If you want the popups to disappear automatically
" after a while, you may also use ToggleFor(duration):
nnoremap <silent> <leader>here :call you_are_here#ToggleFor(2500)<CR>

" Optional: 

" If you want to add a different (shorter?) map
" to close the popups, that option is available.
" I personally prefer to use <ESC> but that's a bit
" intrusive so I don't endorse it :)
nnoremap <silent> <leader>bye :call you_are_here#Close()<CR>

" Most users wouldn't need to manually refresh you-are-here
" while it's open, but it's possible:
nnoremap <silent> <leader>upd :call you_are_here#Update()<CR>
```

## Usage

Activate `you-are-here.vim` by using the keybinding above
(the recommended binding is `<leader>here`).  While the
popups are active, use `m1` to switch to window `1`, `m2`
to switch to window `2`, and so on.  These mappings are
configurable and users can opt-out from these small
conveniences if they prefer plugins that don't map keys.

`<leader>here` will close the popups and unmap the
aforementioned mappings, as will the optional mapping to
`you_are_here#Close()`.

## Config

|Variable|Default|Notes|
|---|---|---|
|`g:youarehere_switch_window_mapping_prefix`|`"m"`|While the popups are open, `you-are-here.vim` adds a keymapping to switch windows easily. `m1` focuses window `1`, `m2` focuses window `2`, and so on.  If you wish for a different prefix, such as `<leader>w`, pass it as a string literal `"<leader>w"`|
|`g:youarehere_enable_switch_window_mappings`|`1`|Turn off the map described above by assigning `0` to this variable|
|`g:youarehere_content`|`"%"`|The argument passed to `expand()`.  Don't touch this without referring to `:help expand`|
|`g:youarehere_padding`|`[1, 1, 1, 1]`|How many characters of padding on the top, right, bottom, and left of the popup windows|
|`g:youarehere_border`|`[1, 1, 1, 1]`|How thick the border is at the top, right, bottom, and left of the popup windows|
|`YouAreHereText`|`Pmenu`|Highlight group for inactive popup content|
|`YouAreHereBorder`|`Pmenu`|Highlight group for inactive popup borders|
|`YouAreHereScrollbar`|`PmenuSbar`|Highlight group for inactive popup scrollbars|
|`YouAreHereThumb`|`PmenuThumb`|Highlight group for inactive popup scrollbar thumb|
|`YouAreHereActiveText`|`Pmenu`|Highlight group for active popup content|
|`YouAreHereActiveBorder`|`PmenuSel`|Highlight group for active popup borders|
|`YouAreHereActiveScrollbar`|`PmenuSbar`|Highlight group for active popup scrollbars|
|`YouAreHereActiveThumb`|`PmenuThumb`|Highlight group for active popup scrollbar thumb|
