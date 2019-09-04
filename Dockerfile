FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
      git \
      stow \
      apt-utils \
      curl \
      make \
      automake \
      wget \
      software-properties-common \
      autotools-dev \
      build-essential \
      pkg-config \
      libevent-dev \
      libncurses5-dev \
      bison \
      byacc \
      libbz2-dev \
      libffi-dev \
      liblzma-dev \
      libncurses5-dev \
      libncursesw5-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      llvm \
      python-openssl \
      python3-dev \
      python3-venv \
      xz-utils \
      # tmux dependencies
      tar \
      libncurses-dev \
      locales \
      zlib1g-dev \
      exuberant-ctags \
      fonts-hack-ttf \
      htop \
      jq \
      manpages-dev \
      manpages-posix-dev \
      python-pygments \
      tree \
      xclip \
      xsel \
      # tk-dev \
      && apt-get clean && rm -rf /var/lib/apt/list/*
      
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Neovim install
RUN add-apt-repository ppa:neovim-ppa/stable && \
      apt-get update && \
      apt-get install -y neovim && \
      apt-get clean && rm -rf /var/lib/apt/list/*

# Tmux 2.6 install
RUN VERSION=2.6 && \
      mkdir ~/tmux-src && \
      wget -qO- https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz | tar xvz -C ~/tmux-src && \
      cd ~/tmux-src/tmux* && \
      ./configure && make -j"$(nproc)" && make install && \
      cd && rm -rf ~/tmux-src

# Install dotfiles for root
RUN git clone https://github.com/cgironalas/dotfiles.git && cd dotfiles && make dotfiles

# Set docker sudo pass
RUN echo "root:Docker!" | chpasswd

# Create user
RUN useradd -u 1000 -m carlos
RUN usermod -a -G sudo carlos
USER carlos
WORKDIR /home/carlos/

# Neovim VimPlug install
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ASDF install
RUN git clone https://github.com/asdf-vm/asdf.git /home/carlos/.asdf && \
      cd .asdf && \
      git checkout "$(git describe --abbrev=0 --tags)" && \
      chown carlos:carlos -R /home/carlos/.asdf

# Install asdf python, nodejs, yarn
RUN /home/carlos/.asdf/bin/asdf plugin-add python && \
      /home/carlos/.asdf/bin/asdf plugin-add nodejs && \
      /home/carlos/.asdf/bin/asdf plugin-add yarn
# Python Versions
RUN /home/carlos/.asdf/bin/asdf install python 2.7.15 && \
      /home/carlos/.asdf/bin/asdf install python 3.7.4 && \
      /home/carlos/.asdf/bin/asdf global python 2.7.15 && \
      /home/carlos/.asdf/shims/pip install -U pip pynvim requests mysql-connector
# Node requirement
RUN /home/carlos/.asdf/plugins/nodejs/bin/import-release-team-keyring
# Nodejs versions
RUN PATH=$PATH:/home/carlos/.asdf/bin asdf install nodejs 12.9.1 && \
      PATH=$PATH:/home/carlos/.asdf/bin asdf global nodejs 12.9.1
# Yarn versions
RUN /home/carlos/.asdf/bin/asdf install yarn 1.17.3 && \
      /home/carlos/.asdf/bin/asdf global yarn 1.17.3

# Install dotfiles
RUN git clone https://github.com/cgironalas/dotfiles.git && cd dotfiles && make dotfiles