
# quickDocs ![Icon](https://github.com/mdh34/quickDocs/raw/master/data/icons/64/com.github.mdh34.quickdocs.svg?sanitize=true)


![build](https://travis-ci.org/mdh34/quickDocs.svg?branch=master) [![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.mdh34.quickdocs)﻿

A fast developer docs reader
![Screenshot](https://raw.githubusercontent.com/mdh34/quickDocs/master/data/images/screenshot-1.png)

## Sources:
 - Valadoc
 - DevDocs (supports viewing docs offline)

## Dependencies:
 - libwebkit2gtk-4.0-dev
 - meson


## Installation:
```
sudo apt install elementary-sdk libwebkit2gtk-4.0-dev meson
git clone https://github.com/mdh34/quickDocs.git
cd ./quickDocs/
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
