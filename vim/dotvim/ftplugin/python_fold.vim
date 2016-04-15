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
        let pnum = prevnonblank(pnum-1)
        let prevind = indent(pnum)
        if pnum < 2
            return 1
        endif
    endwhile

    return pnum
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! GetPythonFold(lnum)
    " Determine folding level in Python source.
    
    let line = getline(a:lnum)
    let prevline = getline(a:lnum - 1)
    let nextline = getline(a:lnum + 1)
    let indlevel = IndentLevel(v:lnum) + 1

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

    if line =~ '^\s*$'
        if prevline =~ '^\s*},\=$' " only either } or }, in line
            return "<" . indlevel
        elseif GetPythonFold(v:lnum - 1) =~ "<"
            return "0"
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

    if line =~ '^\s*$'
        if prevline =~ '^\s*\],\=$' " only either ] or ], in line
            return "<" . indlevel
        elseif GetPythonFold(v:lnum - 1) =~ "<"
            return "0"
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

    " Classes and functions open their own folds:
    if line =~ '^\s*\(class\|def\)\s'
        return ">" . indlevel
    endif

    " Argparse args fold too [ISC]:
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
