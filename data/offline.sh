#!/bin/bash
#taken from https://github.com/grindhold/my_valadoc

DESTDIR="$HOME/.local/share/com.github.mdh34.quickdocs/offline"
mkdir -p $DESTDIR
cd $DESTDIR
curl https://valadoc.org | grep devhelp | cut -c34- | sed 's/">.*$//' | xargs -I{} wget https://valadoc.org/{}
ls *.tar.bz2 | xargs -I{} tar xvfj {}
rm *.tar.bz2
