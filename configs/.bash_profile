export PATH
export MAMP_PHP=/Applications/MAMP/bin/php/php7.1.8/bin
export PATH=~/Library/Python/2.7/bin:$PATH
export PATH=~/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH
export PATH="$MAMP_PHP:$PATH"
export PATH=~/.composer/vendor/bin:$PATH
export PATH=~/dev/flutter/bin:$PATH
export JAVA_HOME=/Library/Java/Home
export ANDROID_HOME=~/Library/Android/sdk

# MacPorts Installer addition on 2017-09-13_at_16:42:06: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export DOTHOME=$HOME/dotfiles
export CLICOLOR=1
export TERM=xterm-256color

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

source "$DOTHOME/configs/bash_helper";
source "$DOTHOME/configs/.k8s_autocomplete";
source "$DOTHOME/configs/.eks_autocomplete";

export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(parse_git_branch)\n\[\033[0m\033[0;32m\]└─ \$\[\033[0m\033[0;32m\]\[\033[0m\] "

files=("$DOTHOME/configs/.ssh_autocomplete", "$DOTHOME/configs/.path" "$DOTHOME/configs/.aliases");

for file in "${files[@]}"; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

unset files file;
