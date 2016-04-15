" Vim folding file
" Language:	Vim
" Author:	Iñaki Silanes
" Last Change:	2016-04-15

map <buffer> f za

setlocal foldmethod=expr
setlocal foldexpr=GetVimFold(v:lnum)
setlocal foldtext=VimFoldText()

function! VimFoldText()
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
    return indent(a:lnum) / &shiftwidth + 1
endfunction

function! GetVimFold(lnum)
    " Determine folding level in Python source.
    
    let line = getline(a:lnum)
    let prevline = getline(a:lnum - 1)
    let nextline = getline(a:lnum + 1)
    let ind  = indent(a:lnum)
    let indlevel = IndentLevel(v:lnum)

    " Open fold for functions:
    if line =~ '^function! '
        return ">" . indlevel
    endif

    " Close fold for functions. A function fold is closed IF:
    " 1) current line is 'endfunctions', and following line is NOT blank
    " 2) current line is blank, and previous line WAS 'endfunctions'
    " In a nutshell: if a blank line follows 'endfunctions' line, join it to
    " fold. Else, close fold at 'endfunctions'
    if line =~ 'endfunction$'
        if nextline =~ '^\s*$'
            return "="
        else
            return "<" . indlevel
        endif
    endif

    if line =~ '^\s*$'
        if prevline =~ 'endfunction$'
            return "<" . indlevel
        else
            return "="
        endif
    endif

    " A single blank line gets the indentation level of previous line
    " if previous line non-blank:
    if line =~ '^\s*$' " blank line
        return "="
    endif

    " Ignore continuation lines:
    if line =~ '\\$'
	return '='
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
