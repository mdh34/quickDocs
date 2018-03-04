#!/bin/bash
#adapted from https://github.com/grindhold/my_valadoc

DESTDIR="$HOME/.local/share/com.github.mdh34.quickdocs"

echo "Trying to create destination directory $DESTDIR …"
mkdir -p $DESTDIR
echo "Entering destination directory $DESTDIR …"
cd $DESTDIR
echo "Downloading archives…"
curl https://valadoc.org | grep devhelp | cut -c34- | sed 's/">.*$//' | xargs -I{} wget https://valadoc.org/{}
echo "Uncompressing and unpacking archives …"
ls *.tar.bz2 | xargs -I{} tar xvfj {}
echo "Removing archives …"
rm *.tar.bz2
