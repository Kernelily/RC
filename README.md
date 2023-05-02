Instructions
========================
## Create Container (Using SSH)
podman run --cap-add AUDIT_WRITE -d --name dmsv --network delta --restart=always -p 8192:8192 -p 19132:19132/udp -p 25565:25565 -v /svf/msf:/svf/msf -v /svf/tmp:/svf/tmp -v /svf/wsf:/svf/wsf dmsv:5.1

podman run --cap-add AUDIT_WRITE -d --name dev --network delta --restart=always -p 87:22 -p 60000-60100:60000-60100/udp -v /svf/msf:/svf/msf -v /svf/tmp:/svf/tmp -v /svf/wsf:/svf/wsf dev:5.1

podman run --cap-add AUDIT_WRITE -d --name sdev --network delta --restart=always -p 86:22 -p 60101-60200:60101-60200/udp sdev:5.1

## Connect To Container
podman exec -it (containerName) /bin/bash

# Let's Setup Our Container
## To Use SSH, Comment Out It!
vim /etc/pam.d/sshd
\# “session required pam_loginuid.so”

## Setup Container 
passwd
systemctl enable --now sshd
vim /etc/ssh/sshd_config
systemctl restart sshd && systemctl status sshd

## Install Langueages && Setup Vim
dnf install java-latest-openjdk-devel gcc g++ swift-lang -y
curl -sL install-node.vercel.app/lts | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

### If There Is No RC, Do This
git clone https://github.com/Kernelily/RC.git 

## Download VimPlug (Vim, NVim)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

## Install Vim Plugins
:PlugInstall

## Install Coc Extensions
:CocInstall coc-clangd coc-java coc-jedi coc-rust-analyzer coc-sh coc-sql coc-tsserver coc-yaml coc-json coc-html coc-css coc-xml coc-cmake coc-copilot coc-docker coc-flutter coc-git coc-emmet coc-highlight coc-prettier coc-pairs coc-spell-checker coc-lightbulb

# Vim Provider Install
npm install -g neovim
pip3 install pynvim

# Install Latest Python
dnf install gcc openssl-devel bzip2-devel sqlite-devel zlib-devel 
wget https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz
tar xzf Python-3.11.3.tgz && cd Python-3.11.3
./configure --enable-optimizations 
make altinstall 

# Generate SSH Key for GitHub Integration
ssh-keygen -t ed25519 -C “Mail“
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

## Register to GitHub Account