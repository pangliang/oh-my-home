
APT="brew"

echo "install chunkwn ..."
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew install koekeishiya/formulae/skhd
rm ~/.chunkwmrc
ln -s $PWD/custom/Darwin/yabairc ~/.yabairc 
rm ~/.skhdrc
ln -s $PWD/custom/Darwin/skhdrc ~/.skhdrc 
brew services restart crisidev/chunkwm/chunkwm
brew services restart skhd

# copy to OS clipboard
brew install reattach-to-user-namespace
