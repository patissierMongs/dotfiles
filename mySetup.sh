#!/bin/bash

# Create symlinks
ln -sf $(pwd)/configure/.vimrc ~/.vimrc
ln -sf $(pwd)/configure/.bashrc ~/.bashrc
ln -sf $(pwd)/configure/.bash_aliases ~/.bash_aliases

# Source the bashrc
source ~/.bashrc
source ~/.vimrc
source ~/.bash_aliases

# post installation
echo "Dotfiles installed successfully!"
