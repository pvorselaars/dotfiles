" 
" init.vim
"

" Plugins

	call plug#begin('~/.config/nvim/plugged')

	Plug 'junegunn/goyo.vim'
	Plug 'rafi/awesome-vim-colorschemes'
	Plug 'PProvost/vim-ps1'
	Plug 'jiangmiao/auto-pairs'
	Plug 'sheerun/vim-polyglot'

	call plug#end()

" Basics
	
	set noswapfile
	let mapleader = " "
	let maplocalleader = ","
	set notitle
	set backspace =indent,eol,start
	syntax on
	set shortmess =I
	set encoding =utf-8
	language en_us

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
	
	" Colors
	colorscheme deep-space
	set t_Co=256

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
	map <leader>a :w<CR> :!compiler %<CR>
	map <leader>r :!%:p:r<CR>
	map <leader>f :Files<CR>
	map <leader>s :term<CR>
	map <F8> :w <CR> :make %<<CR>
	map <F5> :w <CR> :make %<<CR> :!./%<<CR>
	tnoremap <ESC> <C-\><C-n>
	
" Auto completion

	set wildmode =longest,list,full

" Goyo

	map <leader>g :Goyo \| set linebreak \| call Numbers()<CR>

