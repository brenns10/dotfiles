" .vimrc configuration - Stephen Brennan
" --- Begin Portion based on sensible.vim ---
" sensible.vim - Defaults everyone can agree on
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 1
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

set ttimeout
set ttimeoutlen=100

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set laststatus=2
set ruler
set wildmenu

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

inoremap <C-U> <C-G>u<C-U>

" --- End sensible.vim ---
" --- Begin my customization ---
set background=dark
colorscheme solarized
let mapleader=' '

" run commands from the proper directory
set autochdir
" use line numbering
set number
" show tabs
set list
" 80 character guides
set textwidth=80
set cc=+1
" gets rid of startup messages
set shm=I

" MAIL OPTIONS
" Generally speaking, I would like my emails to be wrapped at 75 characters
" rather than 80. This is in line with Linux kernel patch submission guidelines.
" Additionally, mail messages do not have auto line wrapping or any nonsense
" that might disturb a nicely formatted patch.
autocmd FileType mail setlocal textwidth=75

noremap <Leader>! :!

" FORMAT OPTIONS AND WHEN TO USE THEM (:help fo-table)
" *** The following are good for general use. They do not interfere with code
" *** editing, and they make life easier.
" c: auto-wrap comments (this is usally acceptable)
" r: auto insert comment char in INSERT when editing comment
" o: auto insert commend char with o/O in NORMAL
" j: when joining comments, remove comment leader
" q: allow comments to be formatted with gq (Reminder: vipgq to reformat)
set formatoptions=crojq
" t: break text lines over 80 characters as you type them. This absolutely sucks
"    for anything involving code or configuration, but for most text editing it
"    is nice.
autocmd FileType markdown setlocal formatoptions+=t
autocmd FileType text setlocal formatoptions+=t

nnoremap <Leader>gs :!echo --- LATEST OUTPUT ---; git status<Enter>
nnoremap <Leader>gd :!git diff %
" vim:set ft=vim et sw=2:
