# Startup ssh-agent if we're not on osx
unamestr="$(uname)"
if [[ "${unamestr}" == 'Linux' ]]; then
  if [[ "$(ps aux | grep ssh-agent | grep -v grep)" == '' ]]; then
    eval $(ssh-agent -s)
  fi
fi

if [[ "${unamestr}" == 'Darwin' ]]; then
  if [ ! -e '/Library/LaunchDaemons/limit.maxfiles.plist' ]; then
    echo "Need sudo password to update maxfiles and maxfilesperproc for osx"
sudo tee /Library/LaunchDaemons/limit.maxfiles.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>262144</string>
      <string>524288</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
  </dict>
</plist>
EOF

    sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
  fi

  ulimit -n 65536 65536
fi

if [ ! -e ~/.vim/bundles/repos/github.com/Shougo/dein.vim/README.md ]; then
  echo "Installing vim tools, as this is the first time using dotfiles as this user"
  curl -s https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  bash installer.sh ~/.vim/bundles > /dev/null 2>&1
fi


# Load the shell dotfiles, and then some:
for file in ~/.{prompt,exports,aliases}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
