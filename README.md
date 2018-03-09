
# quickDocs ![Icon](https://github.com/mdh34/quickDocs/raw/master/data/icons/64/com.github.mdh34.quickdocs.svg?sanitize=true)


![build](https://travis-ci.org/mdh34/quickDocs.svg?branch=master) [![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.mdh34.quickdocs)

A fast developer docs reader
![Screenshot](https://raw.githubusercontent.com/mdh34/quickDocs/master/data/images/screenshot-1.png)
![Screenshot](https://raw.githubusercontent.com/mdh34/quickDocs/master/data/images/screenshot-3.png)

## Doc Sources:
 - Valadoc
 - DevDocs
 
 Both are avalibale to use offline
## Build Dependencies:
 - libgtk-3-dev
 - libwebkit2gtk-4.0-dev
 - meson
 - valac

## Run Dependencies:
 - curl
 - wget
 - libwebkit2gtk-4.0

## Install:
 - For Debian / Ubuntu based systems, install the latest .deb from [here](https://github.com/mdh34/quickDocs/releases) (64-bit only)

## Install From Source:
The following instructions should work on most debian-based systems:
```
sudo apt install libgtk-3-dev libwebkit2gtk-4.0 libwebkit2gtk-4.0-dev meson valac
git clone https://github.com/mdh34/quickDocs.git
cd ./quickDocs/
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
