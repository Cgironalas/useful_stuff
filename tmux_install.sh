#!/bin/bash

VERSION=2.6

echo "Installing tmux version ${VERSION}..."
mkdir ~/tmux-src && \
wget -qO- https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz | tar xvz -C ~/tmux-src && \
cd ~/tmux-src/tmux* && \
./configure && make -j"$(nproc)" && make install && \
cd && rm -rf ~/tmux-src
echo "Finishing installation..."
