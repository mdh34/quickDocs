
# quickDocs ![Icon](https://github.com/mdh34/quickDocs/raw/master/data/icons/64/com.github.mdh34.quickdocs.svg?sanitize=true)


![build](https://travis-ci.org/mdh34/quickDocs.svg?branch=master)

A fast developer docs reader
![Screenshot](https://raw.githubusercontent.com/mdh34/quickDocs/master/data/images/screenshot-1.png)

## Sources:
 - Valadoc
 - DevDocs (supports viewing docs offline)

## Dependencies:
 - libwebkit2gtk-4.0-dev


## Installation:
```
sudo apt install elementary-sdk libwebkit2gtk-4.0-dev
git clone https://github.com/mdh34/quickDocs.git
mkdir ./quickDocs/build
cd ./quickDocs/build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
sudo make install
```
