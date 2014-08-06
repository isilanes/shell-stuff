" Vim color file
" Maintainer:	Iñaki Silanes
" Last Change:	2003 martxoak 10
" Last Change:	September 26, 2011

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&
set background=light

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "silanes"

highlight Normal        ctermfg=darkblue guifg=darkblue
highlight Normal        guibg=white
highlight section 	ctermfg=black guibg=black
highlight comment 	ctermfg=blue guifg=blue
highlight section 	guifg=darkcyan
highlight kword_list 	ctermfg=black guifg=darkmagenta
highlight kword_var 	ctermfg=black guifg=darkorange
highlight kword_yes 	ctermfg=black guifg=darkgreen
highlight kword_no 	ctermfg=black guifg=darkred
highlight kword2 	ctermfg=black guifg=slateblue
hi        Error         guifg=white   guibg=red  gui=underline
hi        texISCallowed guifg=magenta guibg=white
highlight SpellBad      gui=none guisp=white guifg=white guibg=red
highlight SpellBad      ctermfg=white ctermbg=red
highlight Folded        guifg=darkblue guibg=lightblue

" List of some colors:
"
" cyan,blue,red,green,seagreen,magenta,black,white,gray,yellow
" orange,purple,violet,slateblue,pink
