" Taken from:	Bram Moolenaar <Bram@vim.org>, 1999 Sep 09

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" ISC:
"set guifont=Courier\ Bold\ 12
"set guifont=-Adobe-Courier-Medium-R-Normal--14-140-75-75-M-90-ISO8859-9
"set guifont=Courier\ 10\ Pitch\ 13
"set guifont=Liberation\ Mono\ 10
set guifont=Bitstream\ Vera\ Sans\ Mono\ 10

set guioptions=agl
set shiftwidth=4        " indent with four spaces
set expandtab           " do not convert 8 spaces into a tab
filetype indent on
" end ISC

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

" In text files, always limit the width of text to 78 characters
"autocmd BufRead *.txt set tw=78

" Folders in Python:
"autocmd BufRead *.py set foldmethod=indent

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2,.lz set bin

  autocmd BufReadPost,FileReadPost	*.gz  call GZIP_read("gunzip")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
  autocmd BufReadPost,FileReadPost	*.lz  call GZIP_read("unlzma -S .lz")

  autocmd BufWritePost,FileWritePost	*.gz  call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd BufWritePost,FileWritePost	*.lz  call GZIP_write("lzma -S .lz")

  autocmd FileAppendPre			*.gz  call GZIP_appre("gunzip")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
  autocmd FileAppendPre			*.lz  call GZIP_appre("lzma -S .lz")

  autocmd FileAppendPost		*.gz  call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPost		*.lz  call GZIP_write("unlzma -S .lz")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    let ch_save = &ch
    set ch=2
    execute "'[,']!" . a:cmd
    set nobin
    let &ch = ch_save
    execute ":doautocmd BufReadPost " . expand("%:r")
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      execute "!" . a:cmd . " <afile>:r"
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    execute "!" . a:cmd . " <afile>"
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

endif " has("autocmd")

" Abbrebiations
" For new programs:
ab isgpl #<CR># PROGRAM<CR>#<CR># xxx<CR># (c) 2008, Iñaki Silanes<CR>#<CR># LICENSE<CR>#<CR># This program is free software; you can redistribute it and/or modify it<CR># under the terms of the GNU General Public License (version 2), as<CR># published by the Free Software Foundation.<CR>#<CR># This program is distributed in the hope that it will be useful, but<CR># WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY<CR># or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License<CR># for more details (http://www.gnu.org/licenses/gpl.txt).<CR>#<CR># DESCRIPTION<CR>#<CR>#<CR>#<CR># USAGE<CR>#<CR>#<CR>#<CR># VERSION<CR>#<CR># svn_revision = 1<CR>#

ab pygpl '''<CR>xxx<CR>(c) 2008, Iñaki Silanes<CR><CR>LICENSE<CR><CR>This program is free software; you can redistribute it and/or modify it<CR>under the terms of the GNU General Public License (version 2), as<CR>published by the Free Software Foundation.<CR><CR>This program is distributed in the hope that it will be useful, but<CR>WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY<CR>or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License<CR>for more details (http://www.gnu.org/licenses/gpl.txt).<CR><CR>DESCRIPTION<CR><CR><CR><CR>USAGE<CR><CR><CR><CR>VERSION<CR><CR>svn_revision = 1<CR><CR>'''

ab pyopt <ESC>iimport argparse<CR><CR>def get_args():<CR>"""Read and parse arguments"""<CR><CR>parser = argparse.ArgumentParser()<CR><CR>parser.add_argument('positional',<CR>nargs='+',<CR>metavar="X",<CR>help="Positional arguments")<CR><CR>parser.add_argument("-l", "--long",<CR>help="Description. Default: default.",<CR>action="store_true",<CR>default="default")<CR><CR><CR>return parser.parse_args()<CR><CR><CR><ESC>:set noai<ESC>i#Parse command-line arguments:<CR>o = get_args()<CR><ESC>:set ai<ESC>i

filetype plugin on
colorscheme dracula2
"colorscheme silanes
execute pathogen#infect()
map <F5> :NERDTreeToggle<ESC>
map <C-n> :tabnew<ESC>
map <C-h> :tabp<ESC>
map <C-l> :tabn<ESC>

" For powerline:
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2
set encoding=utf-8
set guifont=Inconsolata\ for\ Powerline\ 12
