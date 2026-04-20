#!/bin/bash

# Colors
RED='\033[0;31m'        
GREEN='\033[0;32m'      
YELLOW='\033[1;33m'     
BLUE='\033[1;34m'       
NC='\033[0m'            

printf "\n${BLUE}====> Installation starting...\n${NC}\n"

# Check if Homebrew is installed, install it if not
if ! command -v brew &> /dev/null; then
    printf "${YELLOW}====> Homebrew not found. Installing Homebrew...${NC}\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to path for the current session (standard for Apple Silicon)
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

printf "\n${BLUE}====> Updating Homebrew\n${NC}\n"
brew update

printf "\n${BLUE}====> Installing Command Line Tools (Compiler/Make)\n${NC}\n"
# This replaces build-essential
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
fi

printf "\n${BLUE}====> Installing dependencies via Homebrew...\n${NC}\n"
# Note: macOS already has zsh, vim, and ssh by default, 
# but Homebrew versions are often newer.
brew install \
wget \
git \
vim \
zsh \
tmux \
tree \
llvm \
cmake \
clang-format

# Tilix is Linux-only. iTerm2 is the standard power-user terminal for Mac.
brew install --cask iterm2

printf "\n${BLUE}====> vim plugin support installation starting...\n${NC}\n"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

printf "\n${BLUE}====> nodejs installation starting...\n${NC}\n"
# On Mac, we don't need the nodesource setup script
brew install node
npm i -g yarn

if [ $? -eq 0 ]
then
    printf "\n${GREEN}====> Installation completed successfully!\n${NC}\n"
else
    printf "\n${RED}====> Error during Installation!\n${NC}\n"
fi