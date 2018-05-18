export DOTHOME=$HOME/dotfiles
export CLICOLOR=1
export TERM=xterm-256color
source "$DOTHOME/configs/bash_helper";

export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(parse_git_branch)\n\[\033[0m\033[0;32m\]└─ \$\[\033[0m\033[0;32m\]\[\033[0m\] "

files=("$DOTHOME/configs/.ssh_autocomplete", "$DOTHOME/configs/.path" "$DOTHOME/configs/.aliases");

for file in "${files[@]}"; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

unset files file;
