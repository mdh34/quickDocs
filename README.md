
# quickDocs ![Icon](https://github.com/mdh34/quickDocs/raw/master/data/icons/64/com.github.mdh34.quickdocs.svg?sanitize=true)


[![build](https://travis-ci.org/mdh34/quickDocs.svg?branch=master)](https://travis-ci.org/mdh34/quickDocs)
[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.mdh34.quickdocs)

A fast developer docs reader
![Screenshot](https://raw.githubusercontent.com/mdh34/quickDocs/master/data/images/screenshot-1.png)
![Screenshot](https://raw.githubusercontent.com/mdh34/quickDocs/master/data/images/screenshot-4.png)

## Doc Sources:
 - Valadoc
 - DevDocs

 Both are avalibale to use offline
## Build Dependencies:
 - libarchive-dev
 - libdevhelp-dev
 - libgee-0.8-dev
 - libgranite-dev
 - libgtk-3-dev
 - libwebkit2gtk-4.0-dev
 - meson
 - valac

## Run Dependencies:
 - libarchive
 - libdevhelp
 - libgee-0.8
 - libgranite
 - libwebkit2gtk-4.0

## Install:
### Flatpak:
 quickDocs is avaliable on Flathub, install it by running:
 ```
 flatpak install flathub com.github.mdh34.quickdocs
 ```
### Distro Packages:
 - For Debian / Ubuntu based systems, install the latest .deb from [here](https://github.com/mdh34/quickDocs/releases) (64-bit only)
 - For Arch Linux based systems, install the AUR package from [here](https://aur.archlinux.org/packages/quickdocs/)
 - For OpenSUSE Leap / Tumbleweed, add the following [repo](https://build.opensuse.org/package/show/home:MichaelAquilina/quickdocs)

## Install From Source:
The following instructions should work on most debian-based systems:
```
sudo apt install libarchive libarchive-dev libgtk-3-dev libdevhelp-dev libdevhelp libwebkit2gtk-4.0 libwebkit2gtk-4.0-dev meson valac
git clone https://github.com/mdh34/quickDocs.git
cd ./quickDocs/
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
