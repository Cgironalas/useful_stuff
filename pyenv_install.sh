#!/bin/bash

VERSION_FOR_GLOBAL=3.7.2
VERSIONS_TO_INSTALL=(${VERSION_FOR_GLOBAL} 2.7.15)

echo "Installing the latest pyenv version"
echo "The following python versions will be installed: "
for i in "${VERSIONS_TO_INSTALL[@]}"; do echo "$i"; done
echo "Where ${VERSION_FOR_GLOBAL} will be configured as global"

curl https://pyenv.run | bash && \
  eval "$(~/.pyenv/bin/pyenv init -)" && \
    for i in "${VERSIONS_TO_INSTALL[@]}"; do
      ~/.pyenv/bin/pyenv install ${i} &
      wait $!
    done

    ~/.pyenv/bin/pyenv global ${VERSION_FOR_GLOBAL} && \
    pip install -U pip && \
    pip install -U neovim
