" Vim syntax file
" Language:	Polyrate-9.1 input file
" Last Change:	2003 Martxoak 10
" Maintainer:	Iñaki Silanes

syntax clear

syn case ignore

" Keyword deffinitions
syn keyword prKeyList		title end atoms restart geom vib elec hessian
syn keyword prKeyList		eact gspec analysis temp constant srange
syn keyword prKeyYes		ivtst0 ivtst1 check bothk cvt tst icvt prdelg
syn keyword prKeyYes		writefu31 zct sct
syn keyword prKeyNo		nosupermol noicvt
syn keyword prKeyVar		energy frequnit geomunit ezero potential
syn keyword prKeyVar		status species linaxis prpart sigmaf sigmar
syn keyword prKeyVar		coord freqscale inh scalemass sstep
syn keyword prKey2		writefu1 central waven atomic nonlints au ang
syn keyword prKey2		read calculate unit29 linrp rps unit31 cart
syn keyword prKey2		slp slm

" Match deffinitions
syn match prComment		/#.*/
syn match prSectionName		/*general/ 
syn match prSectionName		/*energetics/ 
syn match prSectionName		/*second/ 
syn match prSectionName		/*optimization/ 
syn match prSectionName		/*react1/ 
syn match prSectionName		/*react2/
syn match prSectionName		/*prod1/
syn match prSectionName		/*prod2/ 
syn match prSectionName		/*wellr/ 
syn match prSectionName		/*wellp/ 
syn match prSectionName		/*start/ 
syn match prSectionName		/*path/ 
syn match prSectionName		/*tunnel/ 
syn match prSectionName		/*rate/
syn match prKey2m		/y\-axis/

" Color definitions
highlight link prSectionName		section
highlight link prComment		comment
highlight link prKeyList		kword_list
highlight link prKeyVar			kword_var
highlight link prKeyYes			kword_yes
highlight link prKeyNo			kword_no
highlight link prKey2 			kword2
highlight link prKey2m 			kword2

let b:current_syntax = "polyrate"
