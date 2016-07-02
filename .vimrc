" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

source ~/.vimrc.bundles

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
"  set backup		" keep a backup file
  set nobackup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" add by leon
set nu
set ignorecase
set tabstop=4
set shiftwidth=4

color desert

let mapleader=";"
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
imap <C-n> <ESC>

" Tag list {
	map <leader>f :Tlist<CR>
	" let Tlist_Ctags_Cmd = '/home/killer/local/bin/ctags'
	" set tags=/home/killer/workspace/tags
	let Tlist_Exit_OnlyWindow = 1
	let Tlist_Use_Right_Window = 1
	let Tlist_File_Fold_Auto_Close = 1
	let Tlist_Auto_Open = 1
" }

" NerdTree {
	if isdirectory(expand("~/.vim/bundle/nerdtree"))
		map <C-e> <plug>NERDTreeTabsToggle<CR>
		map <leader>e :NERDTreeFind<CR>
		nmap <leader>nt :NERDTreeFind<CR>

		let NERDTreeShowBookmarks=1
		let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
		let NERDTreeChDirMode=0
		let NERDTreeQuitOnOpen=1
		let NERDTreeMouseMode=2
		let NERDTreeShowHidden=1
		let NERDTreeKeepTreeInNewTab=1
		let g:nerdtree_tabs_open_on_gui_startup=0
	endif
" }

" ctrlp {
	if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
		let g:ctrlp_working_path_mode = 'ra'
		nnoremap <silent> <D-t> :CtrlP<CR>
		nnoremap <silent> <D-r> :CtrlPMRU<CR>
		let g:ctrlp_custom_ignore = {
					\ 'dir':  '\.git$\|\.hg$\|\.svn$',
					\ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

		if executable('ag')
			let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
		elseif executable('ack-grep')
			let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
		elseif executable('ack')
			let s:ctrlp_fallback = 'ack %s --nocolor -f'
		else
			let s:ctrlp_fallback = 'find %s -type f'
		endif
		if exists("g:ctrlp_user_command")
			unlet g:ctrlp_user_command
		endif
		let g:ctrlp_user_command = {
					\ 'types': {
					\ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
					\ 2: ['.hg', 'hg --cwd %s locate -I .'],
					\ },
					\ 'fallback': s:ctrlp_fallback
					\ }

		if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
			" CtrlP extensions
			let g:ctrlp_extensions = ['funky']

			"funky
			nnoremap <Leader>fu :CtrlPFunky<Cr>
		endif
	endif
" }

