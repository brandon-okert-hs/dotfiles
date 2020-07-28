cp .hushlogin ~/.hushlogin
cp .aliases ~/.aliases
cp .vimrc ~/.vimrc
cp .osx ~/.osx
cp .gitconfig ~/.gitconfig
mkdir -p .vim/swaps
mkdir -p .vim/backups
mkdir -p .vim/undo
cp -r .vim/colors ~/vim/colors


echo "source ~/.aliases" >> ~/.zshrc
echo "source <(kubectl completion zsh)" >> ~/.zshrc

if [ ! -e ~/.vim/bundles/repos/github.com/Shougo/dein.vim/README.md ]; then
  echo "Installing vim tools, as this is the first time using dotfiles as this user"
  curl -s https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  bash installer.sh ~/.vim/bundles > /dev/null 2>&1
fi
