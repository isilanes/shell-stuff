"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"    Filename: duna.vim                                                   "
" Description: Vim color scheme                                           "
"  Maintainer: Elle518                                                    "
"         URL: http://github.com/Elle518/Duna.git                         "
"                                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark
highlight clear
if exists ("syntax_on")
	syntax reset
endif
let g:colors_name="Duna"

hi ColorColumn term=NONE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c6c6c6
hi Comment term=NONE cterm=NONE ctermbg=NONE ctermfg=58 gui=NONE guibg=NONE guifg=#5f5f00
hi Conceal term=NONE cterm=NONE ctermbg=245 ctermfg=254 gui=NONE guibg=#8a8a8a guifg=#e4e4e4
hi Constant term=NONE cterm=NONE ctermbg=NONE ctermfg=230 gui=NONE guibg=NONE guifg=#ffffdf
hi CursorColumn term=REVERSE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c6c6c6
hi CursorLine term=UNDERLINE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c6c6c6
hi DiffAdd term=NONE cterm=BOLD ctermbg=77 ctermfg=0 gui=BOLD guibg=#5fd75f guifg=#000000
hi DiffDelete term=NONE cterm=BOLD ctermbg=203 ctermfg=0 gui=BOLD guibg=#ff5f5f guifg=#000000
hi DiffChange term=NONE cterm=BOLD ctermbg=229 ctermfg=0 gui=BOLD guibg=#ffffaf guifg=#000000
hi DiffText term=NONE cterm=BOLD ctermbg=123 ctermfg=0 gui=BOLD guibg=#87ffff guifg=#000000
hi Directory term=NONE cterm=NONE ctermbg=NONE ctermfg=106 gui=NONE guibg=NONE guifg=#87af00
hi Error term=REVERSE cterm=NONE ctermbg=196 ctermfg=15 gui=NONE guibg=#ff0000 guifg=#ffffff
hi ErrorMsg term=STANDOUT cterm=NONE ctermbg=NONE ctermfg=196 gui=NONE guibg=NONE guifg=#ff0000
hi Folded term=STANDOUT cterm=NONE ctermbg=236 ctermfg=214 gui=NONE guibg=#303030 guifg=#ffaf00
hi FoldColumn term=STANDOUT cterm=NONE ctermbg=236 ctermfg=214 gui=NONE guibg=#303030 guifg=#ffaf00
hi Identifier term=NONE cterm=NONE ctermbg=NONE ctermfg=106 gui=NONE guibg=NONE guifg=#87af00
hi Ignore ctermfg=0 guifg=bg
hi IncSearch term=REVERSE cterm=REVERSE ctermbg=NONE ctermfg=NONE gui=REVERSE guibg=NONE guifg=NONE

hi helpCommand term=NONE cterm=NONE ctermbg=NONE ctermfg=222 gui=NONE guibg=NONE guifg=#ffdf87
hi helpExample term=NONE cterm=NONE ctermbg=NONE ctermfg=162 gui=NONE guibg=NONE guifg=#d70087
hi link helpNormal Normal
hi link helpSectionDelim Comment

hi LineNr term=NONE cterm=NONE ctermbg=NONE ctermfg=8 gui=NONE guibg=NONE guifg=#888888
hi CursorLineNr term=BOLD cterm=BOLD ctermbg=NONE ctermfg=8 gui=BOLD guibg=NONE guifg=#888888
hi MatchParen term=REVERSE cterm=NONE ctermbg=111 ctermfg=15 gui=NONE guibg=#87afff guifg=#ffffff
hi ModeMsg term=BOLD cterm=BOLD ctermbg=NONE ctermfg=15 gui=BOLD guibg=NONE guifg=#ffffff
hi MoreMsg term=BOLD cterm=NONE ctermbg=NONE ctermfg=104 gui=NONE guibg=NONE guifg=#8787d7

hi link NERDTreeBookmark Constant
hi link NERDTreeBookmarkName Special
hi NERDTreeBookmarkHeader term=BOLD cterm=BOLD ctermbg=NONE ctermfg=129 gui=BOLD guibg=NONE guifg=#af00ff
hi link NERDTreeClosable Directory
hi link NERDTreeOpenable Directory
hi link NERDTreeLinkDir Directory
hi link NERDTreeExecFile Normal
hi link NERDTreeLinkFile Normal
hi link NERDTreeLinkTarget Special
hi link NERDTreeRO Normal
hi NERDTreeUp term=BOLD cterm=BOLD ctermbg=NONE ctermfg=106 gui=BOLD guibg=NONE guifg=#87af00

hi link netrwClassify Identifier
hi link netrwDir Identifier
hi link netrwExe Normal
hi link netrwPlain Normal
hi link netrwSymLink Normal

hi NonText term=NONE cterm=NONE ctermbg=NONE ctermfg=8 gui=NONE guibg=NONE guifg=#888888
hi Normal term=NONE cterm=NONE ctermbg=232 ctermfg=15 gui=NONE guibg=#080808 guifg=#ffffff
hi Pmenu term=NONE cterm=BOLD ctermbg=106 ctermfg=0 gui=BOLD guibg=#87af00 guifg=#000000
hi PmenuSel term=NONE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c6c6c6
hi PmenuSbar term=NONE cterm=NONE ctermbg=242 ctermfg=NONE gui=NONE guibg=#6c6c6c guifg=NONE
hi PmenuThumb term=NONE cterm=NONE ctermbg=15 ctermfg=NONE gui=NONE guibg=#ffffff guifg=NONE
hi PreProc term=NONE cterm=NONE ctermbg=NONE ctermfg=177 gui=NONE guibg=NONE guifg=#d787ff
hi Question term=STANDOUT cterm=NONE ctermbg=NONE ctermfg=104 gui=NONE guibg=NONE guifg=#8787d7
hi Search term=NONE cterm=NONE ctermbg=229 ctermfg=232 gui=NONE guibg=#ffffaf guifg=#333333
hi SignColumn term=NONE cterm=NONE ctermbg=NONE ctermfg=8 gui=NONE guibg=NONE guifg=#888888
hi Special term=NONE cterm=NONE ctermbg=NONE ctermfg=214 gui=NONE guibg=NONE guifg=#ffaf00
hi SpecialKey term=NONE cterm=NONE ctermbg=NONE ctermfg=8 gui=NONE guibg=NONE guifg=#888888
hi SpellBad term=REVERSE cterm=NONE ctermbg=196 ctermfg=15 gui=UNDERCURL guisp=#ff0000
hi SpellCap term=REVERSE cterm=NONE ctermbg=57 ctermfg=15 gui=UNDERCURL guisp=#5f00ff
hi SpellLocal term=REVERSE cterm=NONE ctermbg=14 ctermfg=15 gui=UNDERCURL guisp=#00ffff
hi SpellRare term=REVERSE cterm=NONE ctermbg=13 ctermfg=15 gui=UNDERCURL guisp=#ff00ff
hi Statement term=NONE cterm=NONE ctermbg=NONE ctermfg=129 gui=NONE guibg=NONE guifg=#af00ff
hi StatusLine term=BOLD,REVERSE cterm=BOLD ctermbg=229 ctermfg=232 gui=BOLD guibg=#ffffaf guifg=#080808
hi StatusLineNC term=REVERSE cterm=NONE ctermbg=15 ctermfg=232 gui=NONE guibg=#ffffff guifg=#333333
hi TabLine term=NONE cterm=NONE ctermbg=240 ctermfg=15 gui=NONE guibg=#585858 guifg=#ffffff
hi TabLineSel term=BOLD cterm=NONE ctermbg=232 ctermfg=15 gui=NONE guibg=#080808 guifg=#ffffff
hi TabLineFill term=REVERSE cterm=REVERSE gui=REVERSE
hi Title term=BOLD cterm=NONE ctermbg=NONE ctermfg=177 gui=NONE guibg=NONE guifg=#d787ff
hi Todo term=STANDOUT cterm=BOLD ctermbg=230 ctermfg=0 gui=BOLD guibg=#ffffdf guifg=#000000
hi Type term=NONE cterm=NONE ctermbg=NONE ctermfg=111 gui=NONE guibg=NONE guifg=#87afff
hi Underlined term=UNDERLINE cterm=UNDERLINE ctermbg=NONE ctermfg=111 gui=UNDERLINE guibg=NONE guifg=#87afff
hi VertSplit term=REVERSE cterm=NONE ctermbg=229 ctermfg=232 gui=NONE guibg=#ffffaf guifg=#080808
hi Visual term=REVERSE cterm=NONE ctermbg=236 ctermfg=NONE gui=NONE guibg=#303030 guifg=NONE
hi VisualNOS term=BOLD,UNDERLINE cterm=BOLD,UNDERLINE gui=BOLD,UNDERLINE

hi link vimCommentTitle Comment
hi link vimHiKeyList Normal
hi link vimOption PreProc
hi link vinSetEqual Normal
hi link vimOper Normal

hi WarningMsg term=STANDOUT cterm=NONE ctermbg=NONE ctermfg=229 gui=NONE guibg=NONE guifg=#ffffaf
hi WildMenu term=STANDOUT cterm=BOLD ctermbg=106 ctermfg=232 gui=BOLD guibg=#87af00 guifg=#080808
