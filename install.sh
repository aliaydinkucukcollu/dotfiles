#!/bin/bash

RED='\033[0;31m'        # red
GREEN='\033[0;32m'      # green
YELLOW='\033[1;33m'     # yellow
BLUE='\033[1;34m'       # blue
NC='\033[0m'            # no color

printf "\n${BLUE}====> Installation starting...\n${NC}\n"

printf "\n${BLUE}====> System update\n${NC}\n"
sudo apt-get update

printf "\n${BLUE}====> Common deps installation starting...\n${NC}\n"
sudo apt-get install -y \
wget \
git \
vim \
zsh \
tmux \
tilix \
tree \
openssh-server \
openssh-client \
build-essential \
clang \
clang-tools \
clang-format \
llvm \
lldb

printf "\n${BLUE}====> vim plugin support installation starting...\n${NC}\n"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

printf "\n${BLUE}====> nodejs installation starting...\n${NC}\n"
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm i -g yarn

if [ $? -eq 0 ]
then
    printf "\n${GREEN}====> Installation completed successfully!\n${NC}\n"
else
    printf "\n${RED}====> Error during Installation!\n${NC}\n"
fi