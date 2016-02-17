# List:
alias ls='ls --color=auto -F -b -T 0'
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -lrt'
alias lh='ls -lh'

# Ask before screwing up:
alias cp='nocorrect cp -i'
alias rm='nocorrect rm -i'
alias mv='nocorrect mv -i'

# Don't make nonsense asumptions:
alias ln="nocorrect ln"
alias mkvmerge='nocorrect mkvmerge'
alias mkdir='nocorrect mkdir'

# vim-related:
alias vi='vim -X -u ~/.vimrcs/vim'
alias vil='gvim -geom 125x30+0+0 -u ~/.vimrcs/latex'
alias vip='gvim -geom 100x25 -u ~/.vimrcs/php'
alias vig='gvim -geom 100x25 -u ~/.vimrcs/program'
alias pwsafe='vim ~/.LOGs/GPG/pwsafe.gpg'

# TAR/lzma/gzip...
alias lzma='lzma -S .lz -3'
alias unlzma='unlzma -S .lz'
alias lzcat='lzcat -S .lz'
alias tarx='tar --xz -cvf'
alias untarx='tar --xz -xvf'
alias xz='xz -3'
alias unxz='xz -d'
#alias pxz='cz -l 3 -n 4'

# Functions:
function tf { tail "$1"; echo -n "\033[32m" && tail -0f "$1"; }
function getsound { mplayer -vo null -vc null -ao pcm:file="`echo "$1" | sed -e 's/\...*$/.wav/;s/ /_/g'`":fast "$1";}

# Git:
alias gitc='git commit -a'
alias gitd='git diff --color'
alias gitn='git log --oneline | wc -l'

# svn:
alias svnc='svn commit'
function svnd { svn diff "${@}" | colordiff }

# Other:
alias h='history 1'
alias seek='find ./* -name'
alias itx='ispell -t -x -d american'
alias ps2pdfgood='ps2pdf -dCompatibilityLevel=1.3 -dEmbedAllFonts=true  -dSubsetFonts=true  -dMaxSubsetPct=100 -dAutoFilterColorImages=false -dAutoFilterGrayImages=false -dColorImageFilter=/FlateEncode -dGrayImageFilter=/FlateEncode -dMonoImageFilter=/FlateEncode'
alias df='/bin/df -h | grep -e "dev/[sm]" -e File -e 192'
alias sind='rsync -rltouvh --progress --dry-run --delete --no-whole-file '
alias sindt='rsync -rltouvh --progress --delete --no-whole-file '
alias sin='rsync -rltouvh --progress --dry-run --no-whole-file '
alias sint='rsync -rltouvh --progress --no-whole-file '
alias ega='eval `gpg-agent --daemon`'
alias xmgrace='/usr/bin/xmgrace -barebones -geom 1100x700 -fixed 750 450 -noask'
alias unspace='for f in *[\ \(\)#,\[\]]*; mv $f `echo $f | sed -e "s/ /_/g;s/[]()#,[]//g"`'
alias ihsafe='vim ~/.LOGs/GPG/ihsafe.gpg'
function puttitle { echo -ne "\\033]0;$1\\007" }
alias andromount='sshfs -p 2222 droid:/sdcard /mnt/droid -s -o sshfs_sync -o no_readahead -o cache=no -o follow_symlinks'
alias androumount='fusermount -u /mnt/droid'
