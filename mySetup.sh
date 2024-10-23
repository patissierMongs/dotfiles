#!/bin/bash

# Create symlinks
ln -sf ./configure/.vimrc ~/.vimrc
ln -sf ./configure/.bashrc ~/.bashrc
ln -sf ./configure/.bash_aliases ~/.bash_aliases


# post installation
echo "Dotfiles installed successfully!"
echo "Enter 'source ~/.bashrc NOW!!'"
