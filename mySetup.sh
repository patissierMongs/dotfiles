#!/bin/bash

# Create symlinks
ln -sf ./configure/.vimrc ~/.vimrc
ln -sf ./configure/.bashrc ~/.bashrc
ln -sf ./configure/.bash_aliases ~/.bash_aliases

# Source the bashrc
source ~/.bashrc

# post installation
echo "Dotfiles installed successfully!"
