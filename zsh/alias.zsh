# List:
alias ls='ls --color=auto -F -b -T 0 --hide=__pycache__'
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
alias git="nocorrect git"

# vim-related:
alias vi='vim -u ~/.vimrcs/terminal.vim'
alias vil='gvim -geom 125x30+0+0 -u ~/.vimrcs/latex'
alias vip='gvim -geom 100x25 -u ~/.vimrcs/php'
alias vig='gvim -geom 100x25 -u ~/.vimrcs/program.vim'
alias pwsafe='vi -u ~/.vimrcs/terminal.vim ~/.LOGs/GPG/pwsafe.json.gpg'
alias ihsafe='vi ~/.LOGs/GPG/ihsafe.gpg'

# TAR/lzma/gzip...
alias lzma='lzma -S .lz -3'
alias unlzma='unlzma -S .lz'
alias lzcat='lzcat -S .lz'
alias tarx='tar --xz -cvf'
alias untarx='tar --xz -xvf'
alias xz='xz -3'
alias unxz='xz -d'
alias pxz='cz -l 3 -n 4'

# Functions:
function tf { tail "$1"; echo -n "\033[32m" && tail -0f "$1"; }
function getsound { mplayer -vo null -vc null -ao pcm:file="`echo "$1" | sed -e 's/\...*$/.wav/;s/ /_/g'`":fast "$1";}
function prog { (awk  '/constrained/;/E_KS\(eV\) =/' $1 | tail && tail -n 0 -f $1) | awk '/E_KS\(eV\) =/{de=$4-eks;eks=$4};/constrained/{printf "%.4f %10.4f %7.4f\n",eks,de,$2}' }

# Git:
alias gitc='git commit -a'
alias gitd='git diff --color'
alias gits='git status -s'
alias gitn='git log --oneline | wc -l'

# SVN:
alias svnc='svn commit'
function svnd { svn diff "${@}" | colordiff | less -r}

# rsync:
alias sind='rsync -crltouvh --progress --dry-run --delete --no-whole-file '
alias sindt='rsync -crltouvh --progress --delete --no-whole-file '
alias sin='rsync -rltouvh --progress --dry-run --no-whole-file '
alias sint='rsync -rltouvh --progress --no-whole-file '
alias sinc='rsync -crltouvh --progress --dry-run --no-whole-file '
alias sinct='rsync -crltouvh --progress --no-whole-file '
alias gipsync='python3 ~/git/GitHub/gipsync/gipsync.py'

# screen:
alias screensh='bash ~/git/GitHub/shell-stuff/screen/screen.sh'
alias screen_nep='screen -S neptuno -c "~/git/GitHub/shell-stuff/screen/screenrc.neptuno"'
alias screen_ihdata='screen -S ihdata -c "~/git/GitHub/shell-stuff/screen/screenrc.ihdata"'
alias screen_merc='screen -S mercurio -c "~/git/GitHub/shell-stuff/screen/screenrc.mercurio"'
#alias screen_sk='screen -S skinner -c "~/git/GitHub/shell-stuff/screen/screenrc.skinner"'

# Other:
alias h='history 1'
alias seek='find ./* -name'
alias itx='ispell -t -x -d american'
alias ps2pdfgood='ps2pdf -dCompatibilityLevel=1.3 -dEmbedAllFonts=true  -dSubsetFonts=true  -dMaxSubsetPct=100 -dAutoFilterColorImages=false -dAutoFilterGrayImages=false -dColorImageFilter=/FlateEncode -dGrayImageFilter=/FlateEncode -dMonoImageFilter=/FlateEncode'
alias df='/bin/df -h | grep -v "^udev" | grep -v "^tmpfs" | grep -v "^none" | grep -v "^cgmfs"' 
alias ega='eval `gpg-agent --daemon`'
alias xmgrace='/usr/bin/xmgrace -barebones -geom 1100x825 -fixed 850 600 -noask'
alias unspace='for f in *[\ \(\)#,\[\]]*; mv $f `echo $f | sed -e "s/ /_/g;s/[]()#,[]//g"`'
alias dhmount='sshfs b395676@backup.dreamhost.com:/home/b395676 /mnt/dhback -s -o sshfs_sync -o no_readahead -o cache=no -o follow_symlinks'
alias dhumount='fusermount -u /mnt/dhback'
function puttitle { echo -ne "\\033]0;$1\\007" }
alias p3='source ~/git/GitHub/shell-stuff/zsh/pyenv.sh python-3.5.2'
alias pyenv='source ~/git/GitHub/shell-stuff/zsh/pyenv.sh'
alias cless='bash ~/git/GitHub/shell-stuff/zsh/cless.sh'
