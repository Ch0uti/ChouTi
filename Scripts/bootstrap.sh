#!/bin/bash

currentDir=$(pwd) # store current dir for later use.
cd $(dirname $0) # cd to the command dir.

# Check if a command exists.
function command_exists() { [ -x "$(command -v $1)" ]; }

echo "> Install carthage"
./brew_install_or_upgrade.sh carthage

echo "> Install xcodegen"
./brew_install_or_upgrade.sh xcodegen

# Install gems.
function install_gems() {
  if ! command_exists bundler; then
    sudo gem install bundler
  fi

  bundle check >/dev/null 2>&1 || bundle install
  if [[ $? -ne 0 ]]; then
    echo "> Bundle install failed. Please reinstall bundler"
  fi
}

install_gems

cd $currentDir # restore the dir back.
