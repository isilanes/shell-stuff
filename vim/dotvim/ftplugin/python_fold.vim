" Vim folding file
" Language:	Python
" Author:	Jorrit Wiersma (foldexpr), Max Ischenko (foldtext), Robert
" Ames (line counts)
" Last Change:	2005 Jul 14
" Version:	2.3
" Bug fix:	Drexler Christopher, Tom Schumm, Geoff Gerrietts

" Some changes by: Iñaki Silanes (2013-2014)

map <buffer> f za

setlocal foldmethod=expr
setlocal foldexpr=GetPythonFoldISC(v:lnum)
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

function! GetPythonFoldISC(lnum)
    " Determine folding level in Python source.
    
    let line = getline(a:lnum)
    let ind  = indent(a:lnum)

    " Blank lines maintain the folding level, unless the following line
    " has an indentation level equal to the def or class that started
    " the current fold, in which case the fold ends here.
    if line =~ '^\s*$'
        let nnum = nextnonblank(a:lnum + 1)
        let nind = indent(nnum)
        let psnum = PrevSameLevel(nnum)
        let psline = getline(psnum)
        if psline =~ '^\s*\(class\|def\)\s'
            return "<" . (nind / &sw + 1)
        else
            return "="
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
        return ">" . (ind / &sw + 1)
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
