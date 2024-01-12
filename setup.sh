cp .hushlogin ~/.hushlogin
cp .aliases ~/.aliases
cp .vimrc ~/.vimrc
cp .osx ~/.osx
cp .gitconfig ~/.gitconfig
cp -r .vim ~/.vim

echo "If you don't have brew yet, make sure to install!"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
echo "source ~/.aliases" >> ~/.zshrc
echo "source <(kubectl completion zsh)" >> ~/.zshrc

if [ ! -e ~/.vim/bundles/repos/github.com/Shougo/dein.vim/README.md ]; then
  echo "Installing vim tools, as this is the first time using dotfiles as this user"
  bash installer.sh ~/.vim/bundles > /dev/null 2>&1
fi
