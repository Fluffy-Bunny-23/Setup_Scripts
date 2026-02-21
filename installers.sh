# Install Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz
echo "Lazygit Done"

# Install npm packages
npm install -g opencode-ai copilot > /dev/null 2>&1
echo "NPM Packages Done"

# Install apt packages
sudo apt install btop ncdu -y > /dev/null 2>&1
echo "Btop Done"


# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> /home/zaned31/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/zaned31/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
echo "Brew Done"
