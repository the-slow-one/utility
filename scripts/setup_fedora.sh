#!/usr/bin/sh

###############################################################################
# Warning: If you run this script as sudoer/root package might get install as #
# root user                                                                   #
###############################################################################

if [ "$(id -u)" -eq 0 ]; then
   echo "Error: This script must NOT be run as root or with sudo."
   exit 1
fi

sudo dnf update -y
# Install basics
sudo dnf install -y neovim tmux git clang clang-tools-extra git cmake

# Create and add SSH key to github
yes '' | ssh-keygen -t ed25519 -C "deepakrajhr06@gmail.com"
cat ~/.ssh/id_ed25519.pub
read -p "Add the public key to github, then press Enter: "
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Get utility and setup config files for neovim and tmux
git clone git@github.com:the-slow-one/utility.git
mkdir ~/.config
pushd ~/.config
ln -s ~/utility/config/nvim nvim
ln -s ~/utility/config/starship.toml starship.toml
popd

# Setup tmux
sudo dnf install -y gawk
ln -s ~/utility/dotfiles/tmux.conf .tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install starship
sudo curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Setup neovim
sudo dnf install -y fd-find ripgrep luarocks pip3 rubygems ruby-devel

# neovim perl provider is disabled
#sudo dnf install -y cpanm

# Install neovim provider
pip3 install --user pynvim pyright
sudo npm install -g neovim
sudo gem update --system
gem install neovim --no-document

# neovim perl provider is disabled
#cpanm -n Neovim::Ext

echo "1. Info: Starship will show up on next bash launch"
echo "2. Action: Run lazy plugin manager to setup neovim!"
echo "3. Action: Run tmux and <leader>I to install plugins"
echo
read -p "Setup finished!"
