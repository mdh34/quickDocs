
# quickDocs ![Icon](https://github.com/mdh34/quickDocs/raw/master/data/icons/64/com.github.mdh34.quickDocs.svg?sanitize=true)


quickDocs is a developer docs reader designed for elementary
![Screenshot](https://imgur.com/0t2mmmy.png)

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
