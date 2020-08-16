# you-are-here.vim
📌 See the filenames of your vim splits in easy-to-read popups

![you-are-here.vim screenshot](https://ghcdn.rawgit.org/bignimbus/you-are-here.vim/master/assets/you-are-here.png)

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
contains it.  Pressing `<ESC>` closes the popups.
That's it!  There are several configurable aspects
of the plugin detailed in the below example.

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

"
" Optional configs below
"

" If you want to add a different (shorter?) map
" to close the popups, that option is available
nnoremap <silent> <ESC> :call you_are_here#Close()<CR>

""

" top, right, bottom, left border in popups
let g:youarehere_border = [1, 1, 1, 1]

" top, right, bottom, left padding in popups
let g:youarehere_padding = [1, 1, 1, 1]

" g:content is passed to expand to render the filename.
" see :help expand for more options
let g:content = "%"

" Customize the look of you-are-here.vim by using
" the following highlight groups.

" inactive splits:
"
" YouAreHereText
" YouAreHereBorder
" YouAreHereScrollbar
" YouAreHereThumb

" active split:
"
" YouAreHereActiveText
" YouAreHereActiveBorder
" YouAreHereActiveScrollbar
" YouAreHereActiveThumb
```
