#!/bin/bash

# Check if a command exists.
function command_exists() { [ -x "$(command -v $1)" ]; }

# Install gems.
function install_gems() {
  if ! command_exists bundler; then
    echo "Install 'bundler'"
    sudo gem install bundler
  fi

  bundle check >/dev/null 2>&1 || bundle install
}

install_gems
