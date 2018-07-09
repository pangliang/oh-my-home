
APT="brew"

echo "install chunkwn ..."
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew install koekeishiya/formulae/khd
rm ~/.chunkwmrc
ln -s $PWD/Darwin/chunkwmrc ~/.chunkwmrc 
rm ~/.khdrc
ln -s $PWD/Darwin/khdrc ~/.khdrc 
brew services restart crisidev/chunkwm/chunkwm
brew services restart khd

# copy to OS clipboard
brew install reattach-to-user-namespace
