#!/usr/bin/env bash

source ./command/echos.sh
source ./command/installer.sh

print "Dotfiles 설치를 시작합니다."

print "설치를 하기위해서 sudo 비밀번호가 필요합니다.\n"
if ! sudo grep --silent 'Defaults !tty_tickets' /etc/sudoers; then
  running "sudo tty_tickets 설정"
  sudo bash -c 'echo "Defaults !tty_tickets" | (EDITOR="tee -a" visudo)'
  ok
fi

DOTHOME="${1:-${PWD}}"
rm -rf ./configs-custom
cp -r ./configs ./configs-custom
git submodule update --init --recursive

while true; do
  read -r -p "gitconfig --global name: " name
  if [[ ! $name ]];then
    error "필수로 입력해주세요."
  else
    sed -i '' "s/GITNAME/$name/" ./configs-custom/.gitconfig;
    break
  fi
done

while true; do
  read -r -p "gitconfig --global email: " email
  if [[ ! $email ]];then
    error "필수로 입력해주세요."
  else
    sed -i '' "s/GITEMAIL/$email/" ./configs-custom/.gitconfig;
    break
  fi
done

while true; do
  read -r -p "Github username: " username
  if [[ ! $username ]];then
    error "필수로 입력해주세요."
  else
    sed -i '' "s/GITHUBUSER/$username/" ./configs-custom/.gitconfig;
    break
  fi
done
running "gitconfig"
ok

###
bot "Homebrew (CLI Packages), Caskroom"
###
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  running "homebrew 설치"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
  ok
else
  running "homebrew 업데이트"
  print "\n"
  brew update
  ok

  running "brew 패키지 업그레이드"
  print "\n"
  brew upgrade
  ok
fi

output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
  ibrew caskroom/cask/brew-cask
fi
running "Caskroom 업데이트"
brew tap caskroom/versions > /dev/null 2>&1
ok

###
bot "font install"
###
cd $DOTHOME && chmod +x ./fonts/install.sh
./fonts/install.sh

###
bot "install Mac Os Apps"
###
icask google-chrome
icask simplenote
icask jandi
icask slack
icask trello

###
bot "docker"
###
icask docker
icask docker-toolbox

###
bot "ide and dev tool"
###
icask sourcetree
icask phpstorm
icask visual-studio-code
icask android-studio
icask staruml
icask iterm2
icask sequel-pro

###
bot "Angular Development Environment setting"
###
ibrew node

running "Angular install"
npm install -g @angular/cli
ok

running "Set yarn default package manager"
npm install -g yarn
ng set -g packageManager=yarn
ok