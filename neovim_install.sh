#!/bin/bash

echo "Installing neovim and vimplug..."
if [[ $(command -v apt) ]]; then
  echo "Using apt to add repository then install"
  sudo add-apt-repository ppa:neovim-ppa/stable && \
       apt-get update && \
       apt-get install -y neovim

  wait $!

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [[ $(command -v pacman) ]]; then
  echo "Using arch pacman and yay"
  sudo pacman -Sy neovim

  wait $!

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
