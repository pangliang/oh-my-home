#!/bin/bash

# env
PWD=`pwd`

# os custom
os=`uname`
customfile="$PWD/custom/$os/$os.bash"
if [ -f "$customfile" ]
then
	echo "load custom file $customfile"
	source $customfile 
fi

# git
$APT install git

# modules update
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update
git submodule foreach git pull origin master
git submodule foreach git checkout master

# vim
$APT install vim lua5.1 luajit

rm -rf ~/.vim ~/.vimrc

ln -s $PWD/oh-my-vim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
vim +PluginInstall +qall

# zsh
$APT install zsh

rm -rf ~/.oh-my-zsh ~/.zshrc

ln -s $PWD/oh-my-zsh ~/.oh-my-zsh
cp -rf ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# tmux
$APT install tmux
rm -rf ~/.tmux ~/.tmux.conf ~/.tmux.conf.local

ln -s $PWD/oh-my-tmux ~/.tmux
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.tmux/.tmux.conf.local ~/.tmux.conf.local


