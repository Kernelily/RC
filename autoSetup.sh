#!bin/bash
echo -e "Setting Up Development Environment...\n"

cd $HOME 
echo -e "Changed Current Dirctory to $HOME"

echo -e "Patching \"/etc/pam.d/sshd\""
# if (No need to add "#", Pass this process...)
if [[ -z "$(sed -n '/pam_loginuid.so/ s/^s//p' /etc/pam.d/sshd)" ]]; then
    echo -e "Already Patched (/etc/pam.d/sshd)\nPassing This Process..."
else # The line including "pam_loginuid.so" starts with "s"ession 
    sed -i '/pam_loginuid.so/ s/^/# /' /etc/pam.d/sshd
    echo "Successfully Patched (/etc/pam.d/sshd)"
fi

echo -e "\nSet This Container's \"root\" Password"
#passwd 

# Enalbe "sshd"
echo "Configuring \"sshd\""
systemctl enable --now sshd

# This Will be Deprecated Soon Due to Security Issues
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Installing Some Langueages and so on...
dnf install java-latest-openjdk-devel gcc g++ swift-lang -y
#curl -sL install-node.vercel.app/lts | bash
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
echo "\nInstalled Some Langueages and so on"

# Clone RC Files to ~/.tmp
mkdir $HOME/.tmp
git clone https://github.com/Kernelily/RC.git $HOME/.tmp/
cp -r $HOME/.tmp/.vimrc $HOME/
cp -r $HOME/.tmp/.config $HOME/
echo -e "\nCloned RC files to $HOME/.tmp\nAnd Copyed them to $HOME"

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
fi

# Install Coc LSP 
echo -e "\nInstalling Coc LSPs\nThis might take a while..."
vim +CocInstall coc-clangd coc-java coc-jedi coc-rust-analyzer
vim +CocInstall coc-sh coc-sql coc-tsserver coc-yaml coc-json coc-html coc-css coc-xml coc-cmake
vim +CocInstall coc-copilot coc-docker coc-flutter coc-git coc-emmet coc-highlight coc-prettier
vim +CocInstall coc-pairs coc-spell-checker coc-lightbulb

# Generate SSH Key for GitHub Integration
echo -e "\nEnter GitHub eMail Address => "
read gitHubMail

ssh-keygen -t ed25519 -C “$gitHubMail“ && eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519 && cat ~/.ssh/id_ed25519.pub

echo -e "\nFinished!"
