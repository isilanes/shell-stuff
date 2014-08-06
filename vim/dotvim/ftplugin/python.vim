" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
finish
endif
let b:did_ftplugin = 1

map <buffer> f za

setlocal foldmethod=expr
setlocal foldexpr=(getline(v:lnum)=~'^$')?-1:((indent(v:lnum)<indent(v:lnum+1))?('>'.indent(v:lnum+1)):indent(v:lnum))
set foldtext=getline(v:foldstart)
set fillchars=fold:\ "(there's a space after that \)
