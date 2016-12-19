#1/bin/bash

# env
PWD=`pwd`
APT='sudo apt-get'


# cygwin
if [[ $(uname) =~ 'CYGWIN' ]];then
	APT='apt-cyg'
	rm ~/.minttyrc
	ln -s $PWD/cygwin/minttyrc ~/.minttyrc
fi

# macos
if [[ $(uname) =~ 'Darwin' ]];then
	APT='brew'
fi

# git
sudo $APT install git

git config --global user.email "418094911@qq.com"
git config --global user.name "pangliang"

# modules update
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update
git submodule foreach git pull origin master
git submodule foreach git checkout master

# vim
$APT install vim lua

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




