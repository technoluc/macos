#!/usr/bin/env bash

source ./lib_sh/echos.sh
source ./lib_sh/requirers.sh

echo ""
cecho "###############################################" $red
cecho "#                                             #" $red
cecho "#                                             #" $red
cecho "#      TechnoLuc's macos bootstrap script     #" $red
cecho "#                                             #" $red
cecho "#                                             #" $red
cecho "###############################################" $red
echo ""

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."


echo ""
cecho "Have you read through the script you're about to run and " $red
cecho "understood that it will make changes to your computer? (y/n)" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" $red
  exit
fi

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Do we need to ask for sudo password or is it already passwordless?
grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$LOGNAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  botq "Do you want me to setup this machine to allow you to run sudo without a password?\nPlease read here to see what I am doing:\nhttp://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n"

  read -r -p "Make sudo passwordless? [y|N] " response

  if [[ $response =~ (yes|y|Y) ]];then
      if ! grep -q "#includedir /private/etc/sudoers.d" /etc/sudoers; then
        echo '#includedir /private/etc/sudoers.d' | sudo tee -a /etc/sudoers > /dev/null
      fi
      echo -e "Defaults:$LOGNAME    !requiretty\n$LOGNAME ALL=(ALL) NOPASSWD:     ALL" | sudo tee /etc/sudoers.d/$LOGNAME
      botq "You can now run sudo commands without password!" $green
  fi
fi

echo ""
botq "Source General dotfile? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  source ./general.sh
fi

echo ""
botq "Source Finder dotfile? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  source ./finder.sh
fi

echo ""
botq "Source Adblock dotfile? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  source ./adblock.sh
fi

echo ""
botq "Source Git dotfile? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  source ./git.sh
fi

echo ""
botq "Source Xcode dotfile? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  source ./xcode.sh
fi

echo ""
botq "Source Brew dotfile? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  source ./brew.sh
fi

botc "All done! Enjoy your mac" $green
