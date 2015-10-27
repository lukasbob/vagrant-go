#!/bin/bash

echo "Updating apt-get"
sudo apt-get update

echo "Installing golang, git & chrome"
sudo apt-get install -y golang git libexif12 libexif-dev chromium-browser dbus-x11 xvfb 

echo "Establishing a Go dev environment."

echo "export GOPATH=~/go" >> /home/vagrant/.bashrc; export GOPATH=/home/vagrant/go

go get github.com/nsf/gocode
go get code.google.com/p/go.tools/cmd/godoc


echo "Build vim with lua"

# Remove previous installations
sudo apt-get remove vim vim-runtime vim-tiny vim-common

# Install dependencies
sudo apt-get install -y libncurses5-dev python-dev libperl-dev ruby-dev liblua5.2-dev

# Fix liblua paths
sudo ln -s /usr/include/lua5.2 /usr/include/lua
sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.2.so /usr/local/lib/liblua.so

# Clone vim sources
git clone https://github.com/vim/vim.git

cd vim
./configure --prefix=/usr     \
    --enable-luainterp=yes    \
    --enable-perlinterp=yes   \
    --enable-pythoninterp=yes \
    --enable-rubyinterp=yes   \
    --enable-cscope           \
    --disable-netbeans        \
    --enable-multibyte        \
    --enable-largefile        \
    --enable-gui=no           \
    --with-features=huge      \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu

make VIMRUNTIMEDIR=/usr/share/vim/vim74

sudo apt-get install -y checkinstall
sudo checkinstall

echo "Setting up pathogen & go bundles"

mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
git clone https://github.com/fatih/vim-go.git
git clone https://github.com/scrooloose/nerdtree.git
git clone git://github.com/tpope/vim-fugitive.git