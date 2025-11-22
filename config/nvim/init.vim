" 
" init.vim
"

" Plugins

	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
	if empty(glob(data_dir . '/autoload/plug.vim'))
	  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
	call plug#begin('~/.vim/plugged')

	Plug 'junegunn/goyo.vim'
	Plug 'rafi/awesome-vim-colorschemes'
	Plug 'PProvost/vim-ps1'
	Plug 'jiangmiao/auto-pairs'
	Plug 'sheerun/vim-polyglot'

	call plug#end()

" Basics

	if has("win64")
		set shell=pwsh
		set shellcmdflag=-c
		set shellquote=
		set shellxquote=
	endif


	set noswapfile
	let mapleader = " "
	let maplocalleader = ","
	set notitle
	set backspace =indent,eol,start
	syntax on
	set shortmess =I
	set encoding =utf-8
	set expandtab

	set hidden
	set confirm

	" Statusline	
	set laststatus=2
	set statusline=%f	" Path to the file
	set statusline+=%= 	" Switch sides
	set statusline+=%l/%L\  " Line numbers
	set statusline+=%y	" Filetype of the file

	set noshowmode
	set autochdir

	function Numbers()
		set number relativenumber
		highlight LineNr ctermfg=darkgrey
		highlight CursorLineNr ctermfg=white
	endfunction
	
	call Numbers()

	" Keybindings
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
	map <leader>m :w<CR> :make<CR>
	map <leader>a :w<CR> :!compiler % 
	map <leader>f :w<CR> :!formatter % <CR>
	map <leader>d :w<CR> :!compiler % <CR> :term gdb -tui %:r <CR>
	map <leader>r :!%:p:r<CR>
	map <leader>s :term<CR>
	map <F8> :w <CR> :make %<<CR>
	map <F5> :w <CR> :make %<<CR> :!./%<<CR>
	tnoremap <ESC> <C-\><C-n>
	map <leader>b :ls<CR>:b<Space>
	map <leader>v :ls<CR>:vsp \|<Space>b<Space>
	map <leader>h :ls<CR>:sp \|<Space>b<Space>
	map <leader>o :on<CR>
	
" Auto completion

	set wildmode =longest,list,full

" Goyo

	map <leader>g :Goyo \| set linebreak \| call Numbers()<CR>

" Binary editing

	augroup Binary
	  autocmd!
	  autocmd BufReadPre  *.bin set binary
	  autocmd BufReadPost *.bin
	    \ if &binary
	    \ |   execute "silent %!xxd"
	    \ |   set filetype=xxd
	    \ |   redraw
	    \ | endif
	  autocmd BufWritePre *.bin
	    \ if &binary
	    \ |   let s:view = winsaveview()
	    \ |   execute "silent %!xxd -r"
	    \ | endif
	  autocmd BufWritePost *.bin
	    \ if &binary
	    \ |   execute "silent %!xxd"
	    \ |   set nomodified
	    \ |   call winrestview(s:view)
	    \ |   redraw
	    \ | endif
	augroup END
