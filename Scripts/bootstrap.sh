#!/bin/bash

# Check if a command exists.
function command_exists() { [ -x "$(command -v $1)" ]; }

echo "Install carthage"
brew install carthage

echo "Install xcodegen"
brew install xcodegen

echo "Install swiftlint"
brew install swiftlint

# Install gems.
function install_gems() {
  if ! command_exists bundler; then
    sudo gem install bundler
  fi

  bundle check >/dev/null 2>&1 || bundle install
}

install_gems
