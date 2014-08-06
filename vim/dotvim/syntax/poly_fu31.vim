" Vim syntax file
" Language:	Polyrate-9.1 fu31 file
" Last Change:	2003 Martxoak 19
" Maintainer:	Iñaki Silanes

syntax clear

syn case ignore

" Keyword deffinitions
syn keyword fu31KeyList		geom end grads hessian
syn keyword fu31KeyVar		enersad enerxn smep vmep
syn keyword fu31Key2		ang uns au forces packed

" Match deffinitions
syn match fu31Comment		/#.*/
syn match fu31SectionName	/*general/
syn match fu31SectionName	/*react1/
syn match fu31SectionName	/*react2/
syn match fu31SectionName	/*prod1/
syn match fu31SectionName	/*prod2/
syn match fu31SectionName	/*saddle/
syn match fu31SectionName	/*point/

" Color definitions
highlight link fu31SectionName		section
highlight link fu31SectionEnd		section
highlight link fu31Comment		comment
highlight link fu31KeyVar		kword_var
highlight link fu31KeyList		kword_list
highlight link fu31Key2			kword2

let b:current_syntax = "poly_fu31"
