#!bin/bash
echo -e "autoSetup.sh\n\
    - Patch \"/etc/pam.d/sshd\"\n\
    - Set \"root\" Password\n\
    - Enable \"sshd\"\n\
    - Install Programming Languages\n\
    - Install RC Files\n\
    - Generate SSH Key for GitHub Integration\n\
    \n\nThis Script Will Take a While\nPlease Wait...\n"

echo -e "\n\nEnter \"root\" Password => "
read rootPass

echo -e "\nEnter GitHub eMail Address => "
read gitHubMail

echo -e "\nSetting Up Development Environment...\n"

# Wait 5 Seconds
sleep 5

cd $HOME && mkdir -p $HOME/.tmp/{.rc, .python}
echo -e "Changed Current Dirctory to $HOME\n\
    And Created .tmp Dirctory\n"

echo -e "Patching \"/etc/pam.d/sshd\""

# if (No need to add "#", Pass this process...)
if [[ -z "$(sed -n '/pam_loginuid.so/ s/^s//p' /etc/pam.d/sshd)" ]]; then
    echo -e "Already Patched (/etc/pam.d/sshd)\nPassing This Process...\n"
else # The line including "pam_loginuid.so" starts with "s"ession 
    sed -i '/pam_loginuid.so/ s/^/# /' /etc/pam.d/sshd
    echo "Successfully Patched (/etc/pam.d/sshd)\n"
fi

echo -e "Set This Container's \"root\" Password\n"
echo -e "'$rootPass'\n'$rootPass'" | passwd

# Wait 5 Seconds
sleep 5

# Enalbe "sshd"
echo "Configuring \"sshd\""
systemctl enable --now sshd
# This Will be Deprecated Soon Due to Security Issues
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Wait 5 Seconds
sleep 5

# Installing Some Langueages and so on...
echo -e "\nInstalling Some Langueages and so on"
dnf install java-latest-openjdk-devel gcc g++ swift-lang pip clang-tools-extra \
    openssl-devel bzip2-devel sqlite-devel zlib-devel -y
curl -sL install-node.vercel.app/lts | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Wait 5 Seconds
sleep 5

# Install Latest Python
echo -e "\nInstalling Latest Python"
cd $HOME/.tmp/.python && wget https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz
tar xzf Python-3.11.3.tgz && cd Python-3.11.3
./configure --enable-optimizations && make altinstall

# Wait 5 Seconds
sleep 5

# Clone RC Files to ~/.tmp
git clone git@github.com:Kernelily/RC.git $HOME/.tmp/
cp -r $HOME/.tmp/.vimrc $HOME/
cp -r $HOME/.tmp/.config $HOME/
echo -e "\nCloned RC files to $HOME/.tmp\nAnd Copyed them to $HOME"

# Wait 5 Seconds
sleep 5

# Setup Vim Development Environment
echo -e "\nDownloading \"vim-plug\" for Vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall 

if which nvim > /dev/null; then
    echo -e "\nDownloading \"vim-plug\" for NeoVim"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    nvim +PlugInstall

    # Install NeoVim Provider
    echo -e "\nInstalling NeoVim Providers"
    npm install -g neovim && pip3 install pynvim neovim
fi

# Wait 5 Seconds
sleep 5

# Generate SSH Key for GitHub Integration
ssh-keygen -t ed25519 -C “$gitHubMail“ && eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519 && cat ~/.ssh/id_ed25519.pub

# Wait 5 Seconds
sleep 5

# Install Coc LSP 
nvim '+CocInstall coc-clangd coc-java coc-jedi coc-rust-analyzer coc-sh \
    coc-sql coc-tsserver coc-yaml coc-json coc-html coc-css coc-xml coc-cmake \
    coc-copilot coc-docker coc-flutter coc-git coc-emmet coc-highlight coc-prettier \
    coc-pairs coc-spell-checker coc-lightbulb'

echo -e "\nFinished!"
