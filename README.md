# Instructions
## _The Instruction of Run Configuration_

The instruction to make a develop container.

- Create Container (Podman)
- Install Programming Languages Compiler
- Install RC files and Configure

## Create Container and Connect (Host, Podman)
```sh
podman run --cap-add AUDIT_WRITE -d --name dmsv --network delta --restart=always -p 8192:8192 -p 19132:19132/udp -p 25565:25565 -v /svf/msf:/svf/msf -v /svf/tmp:/svf/tmp -v /svf/wsf:/svf/wsf dmsv:5.1
podman run --cap-add AUDIT_WRITE -d --name dev --network delta --restart=always -p 87:22 -p 60000-60100:60000-60050/udp -v /svf/msf:/svf/msf -v /svf/tmp:/svf/tmp -v /svf/wsf:/svf/wsf dev:5.1
podman run --cap-add AUDIT_WRITE -d --name sdev --network delta --restart=always -p 86:22 -p 60101-60200:60051-60100/udp sdev:5.1
```

Connect Container
```sh
podman exec -it (containerName) /bin/bash
```

## Setup Container
To use SSH, Run this command
```sh
sed -i '/pam_loginuid.so/ s/^/# /' /etc/pam.d/sshd
```

Set Root Password, Add \"password\" Method to Authentication Method 
```sh
passwd && systemctl enable --now sshd
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd && systemctl status sshd
```

Install Languages && Setup Vim
```sh
dnf install java-latest-openjdk-devel gcc g++ swift-lang clang-tools-extra openssl-devel bzip2-devel sqlite-devel zlib-devel -y
curl -sL install-node.vercel.app/lts | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

Install Latest Python
```sh
curl -fLo ~/.tmp/Python-3.11.3.tgz --create-dirs \
    https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz
tar xzf Python-3.11.3.tgz && cd Python-3.11.3
./configure --enable-optimizations && make altinstall 
```

Download VimPlug (Vim, NVim)
For Vim
```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

For NeoVim
```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Install Vim Provider
```sh
npm install -g neovim && pip3 install pynvim neovim
```

Generate SSH Key for GitHub Integration
```sh
ssh-keygen -t ed25519 -C “Mail“
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```
Register the result to GitHub Account

Download pre-configuration files
```sh
mkdir -p ~/.tmp/config && cd ~/.tmp/
git clone https://github.com/Kernelily/RC.git config 
```

Install Vim Plugins
> vim +PlugInstall

> nvim +PlugInstall

Install Coc Extensions
Run in Vim \"NORMAL\" Mode
:CocInstall coc-clangd coc-java coc-jedi coc-rust-analyzer coc-sh coc-sql coc-tsserver coc-yaml coc-json coc-html coc-css coc-xml coc-cmake coc-copilot coc-docker coc-flutter coc-git coc-emmet coc-highlight coc-prettier coc-pairs coc-spell-checker coc-lightbulb
