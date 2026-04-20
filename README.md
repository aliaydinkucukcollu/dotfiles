# ⚙️ Dotfiles

Personal dotfiles for a consistent, fast, and reproducible development environment across **Ubuntu** and **macOS**, with a focus on **C++**, **ROS2**, and modern tooling.

---

## 🚀 Installation

```bash
git clone https://github.com/aliaydinkucukcollu/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

./install.sh

source ~/.bashrc   # or ~/.zshrc

ln -s ~/.dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
```

---
## 🔄 Updating

```bash
cd ~/.dotfiles
git pull
./install.sh
```