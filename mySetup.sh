#!/bin/bash

# Create symlinks
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.bash_aliases ~/.bash_aliases

# Source the bashrc
source ~/.bashrc

# post installation
echo "Dotfiles installed successfully!"
