" Vim syntax file
" Language:	Polyrate-9.1 fu29 file
" Last Change:	2003 Martxoak 18
" Maintainer:	Iñaki Silanes

syntax clear

syn case ignore

" Keyword deffinitions
"syn keyword fu29KeyList	a
"syn keyword fu29KeyYes		b
"syn keyword fu29KeyNo		c
syn keyword fu29KeyVar		barri deltae print units
"syn keyword fu29Key2		e
syn keyword fu29SectionEnd	end

" Match deffinitions
syn match fu29Comment		/#.*/
syn match fu29SectionName	/*ivtst/
syn match fu29SectionName	/*p1freq/
syn match fu29SectionName	/*p2freq/
syn match fu29SectionName	/*r1freq/
syn match fu29SectionName	/*r2freq/
syn match fu29SectionName	/*tsfreq/

" Color definitions
highlight link fu29SectionName		section
highlight link fu29SectionEnd		section
highlight link fu29Comment		comment
"highlight link fu29KeyList		kword_list
highlight link fu29KeyVar		kword_var
"highlight link fu29KeyYes		kword_yes
"highlight link fu29KeyNo		kword_no
"highlight link fu29Key2 		kword2
"highlight link fu29Key2m 		kword2

let b:current_syntax = "poly_fu29"
