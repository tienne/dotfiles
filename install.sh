#!/usr/bin/env bash

source ./command/echos.sh
source ./command/installer.sh

print "Dotfiles 설치를 시작합니다."
print "설치를 하기 위해서는 password가 필요합니다."

sudo -v

while true;
do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done &> /dev/null &

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
cp ./configs-custom/.gitconfig ${HOME}/.gitconfig
running "gitconfig"
ok

###
bot ".bash_profile"
###
ln -nfs $DOTHOME/configs/.bash_profile $HOME/.bash_profile
source $HOME/.bash_profile
running "bash_profile"
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
bot "composer install"
###
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin/
mv /usr/local/bin/composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
sudo chown -R $USER ~/.composer/
ok

###
bot "composer prestissimo install"
###
composer global require hirak/prestissimo
ok

###
bot "python install"
###
ibrew python
ibrew python3
easy_install pip
ok

###
bot "aws sdk install"
###
pip install awscli --upgrade --ignore-installed six
pip install awscli
pip install awsebcli --upgrade --user


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
icask iterm2
icask sequel-pro
icask mysqlworkbench

###
bot "Angular Development Environment setting"
###
ibrew node
ibrew yarn

running "Angular install"
npm install -g @angular/cli
ok

running "typescript install"
npm install -g typescript
ok

running "gulp install"
npm install -g gulp
ok

running "Set yarn default package manager"
npm install -g yarn
ng set -g packageManager=yarn
ok

####
#bot ".DS_STORE file"
####
#
#default write com.apple.desktopservices DSDontWriteNetworkStores true
#ok