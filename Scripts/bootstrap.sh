#!/bin/bash

# Check if a command exists.
function command_exists() { [ -x "$(command -v $1)" ]; }

echo "> Install carthage"
./Scripts/brew_install_or_upgrade.sh carthage

echo "> Install xcodegen"
./Scripts/brew_install_or_upgrade.sh  xcodegen

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
