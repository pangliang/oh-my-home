
echo "install chunkwn ..."
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
rm ~/.chunkwmrc && ln -s $PWD/Darwin/chunkwmrc ~/.chunkwmrc 
rm ~/.khdrc && ln -s $PWD/Darwin/khdrc ~/.khdrc 
brew services restart crisidev/chunkwm/chunkwm
brew services restart khd
