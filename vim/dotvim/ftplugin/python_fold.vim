" Vim folding file
" Language:	Python
" Author:	Jorrit Wiersma (foldexpr), Max Ischenko (foldtext), Robert
" Ames (line counts)
" Last Change:	2005 Jul 14
" Version:	2.3
" Bug fix:	Drexler Christopher, Tom Schumm, Geoff Gerrietts

" Some changes by: Iñaki Silanes (2013-2014, 2016)

map <buffer> f za

setlocal foldmethod=expr
setlocal foldexpr=GetPythonFold(v:lnum)
setlocal foldtext=PythonFoldText()

function! PythonFoldText()
    let line = getline(v:foldstart)
    let nnum = nextnonblank(v:foldstart + 1)
    let nextline = getline(nnum)

    if nextline =~ '^\s\+"""$'
        let line = line . getline(nnum + 1)
    elseif nextline =~ '^\s\+"""'
        let line = line . ' ' . matchstr(nextline, '"""\zs.\{-}\ze\("""\)\?$')
    elseif nextline =~ '^\s\+"[^"]\+"$'
        let line = line . ' ' . matchstr(nextline, '"\zs.*\ze"')
    elseif nextline =~ '^\s\+pass\s*$'
        let line = line . ' pass'
    endif

    let size = 1 + v:foldend - v:foldstart

    if size < 10
        let size = " " . size
    endif
    if size < 100
        let size = " " . size
    endif
    if size < 1000
        let size = " " . size
    endif

    return size . " lines: " . line
endfunction

function! PrevSameLevel(nnum)
    " Returns last preceding nonblank line that has an
    " indentation level equal to or less than line
    " number nnum.

    let currind = indent(a:nnum)

    let pnum = prevnonblank(a:nnum - 1)
    let prevind = indent(pnum)

    while prevind > currind
        let pnum = prevnonblank(a:pnum - 1)
        let prevind = indent(a:pnum)
        if pnum < 2
            return 1
        endif
    endwhile

    return pnum
endfunction

function! WhereBlockBegan(lnum)
    " Returns line number of where recently closed block began
    
    let l:pnum = prevnonblank(a:lnum - 1)
    let line = getline(l:pnum)

    while line !~ '^\s*\(class\|def\)\s'
        let pnum = prevnonblank(l:pnum - 1)
        let line = getline(l:pnum)
        if pnum < 2
            return 1
        endif
    endwhile

    return l:pnum
endfunction

function! IndentLevel(lnum)
    " Blank lines have a nominal indentation level equal to latest non-blank.
    " prevnonblank returns latest non-blank line, but current line if current
    " line is not blank.
    let pnum = prevnonblank(a:lnum)
    return indent(pnum) / &shiftwidth + 1
endfunction

function! GetPythonFold(lnum)
    " Determine folding level in Python source.
    
    let line = getline(a:lnum)
    let prevline = getline(a:lnum - 1)
    let prevprevline = getline(a:lnum - 2)
    let nextline = getline(a:lnum + 1)
    let indlevel = IndentLevel(a:lnum)

    " Classes and functions open their own folds:
    if line =~ '^\s*\(class\|def\)\s'
        return ">" . indlevel
    endif

    " Blank lines close:
    " 1) dictionary if line just above is } o },
    " 2) list if line just above is ] o ],
    " 3) class/def, if:
    "    3.1) previous line is NOT blank (if it is, that one must have closed
    "         the block)
    "    3.2) next non-blank line is LESS indented than itself.
    if line =~ '^\s*$'
        " Close class/def:
        let pnum = WhereBlockBegan(a:lnum)
        if pnum == 1
            return "0"
        endif
        let pindlevel = IndentLevel(l:pnum)

        let nnum = nextnonblank(a:lnum + 1)
        let nindlevel = IndentLevel(l:nnum)

        if prevline !~ '^\s*$' " non-blank
            if nindlevel <= pindlevel
                return "<" . pindlevel
            endif
        endif

        " Close dictionary:
        if prevline =~ '^\s*},\=$' " only either } or }, in line
            return "<" . indlevel
        endif

        " Close list:
        if prevline =~ '^\s*],\=$' " only either ] or ], in line
            return "<" . indlevel
        endif

    endif

    " [ISC] How dictionaries open:
    if line =~ '\( = \|: \){$'
        return ">" . indlevel
    endif

    " [ISC] How dictionaries close:
    if line =~ '^\s*},\=$' " only either } or }, in line
        if nextline =~ '^\s*$'
            return "="
        else
            return "<" . indlevel
        endif
    endif

    " [ISC] How multi-line lists open:
    if line =~ '\( = \|: \)[$'
        return ">" . indlevel
    endif

    " [ISC] How multi-line lists close:
    if line =~ '^\s*],\=$' " only either ] or ], in line
        if nextline =~ '^\s*$'
            return "="
        else
            return "<" . indlevel
        endif
    endif

    " Ignore triple quoted strings:
    if line =~ "(\"\"\"|''')"
	return "="
    endif

    " Ignore continuation lines:
    if line =~ '\\$'
	return '='
    endif

    " Support markers:
    if line =~ '{{{'
	return "a1"
    elseif line =~ '}}}'
	return "s1"
    endif

    " [ISC] Argparse args fold too:
    if line =~ 'parser.add_argument'
        return ">" . indlevel
    endif

    let pnum = prevnonblank(a:lnum - 1)

    if pnum == 0
	" Hit start of file
	return 0
    endif

    " If the previous line has foldlevel zero, and we haven't increased
    " it, we should have foldlevel zero also
    if foldlevel(pnum) == 0
	return 0
    endif

    " The end of a fold is determined through a difference in indentation
    " between this line and the next.
    " So first look for next line
    let nnum = nextnonblank(a:lnum + 1)
    if nnum == 0
	return "="
    endif

    " If none of the above apply, keep the indentation
    return "="

endfunction