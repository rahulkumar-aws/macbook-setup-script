#!/bin/bash

echo "Starting macOS developer setup..."

# Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
xcode-select --install

# Wait until Xcode Command Line Tools are installed
until xcode-select -p &>/dev/null; do
    echo "Waiting for Xcode Command Line Tools to install..."
    sleep 5
done

# Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed!"
fi

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install essential tools
echo "Installing essential tools..."
brew install git curl wget zsh zsh-completions

# Install programming languages
echo "Installing programming languages..."
brew install python node ruby go

# Install Python tools
echo "Installing Python tools..."
brew install pyenv poetry pipx
pipx ensurepath

# Install databases
echo "Installing databases..."
brew install postgresql mysql sqlite

# Install Docker
echo "Installing Docker..."
brew install --cask docker

# Install development tools
echo "Installing development tools..."
brew install --cask visual-studio-code iterm2

# Install browsers
echo "Installing browsers..."
brew install --cask google-chrome firefox

# Install additional useful tools
echo "Installing additional tools..."
brew install --cask slack zoom notion

# Configure git
echo "Configuring Git..."
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor "code --wait"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed!"
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
fi

# Enable Powerlevel10k theme
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Install Zsh plugins
echo "Installing Zsh plugins..."
PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$PLUGIN_DIR"

if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
fi

if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/zsh-autosuggestions"
fi

# Add plugins to .zshrc
sed -i '' 's/^plugins=(.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

# Install Nerd Fonts
echo "Installing Nerd Fonts..."
FONT_DIR="$HOME/Library/Fonts"
FONT_NAME="MesloLGS NF"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"

if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    mkdir -p "$FONT_DIR"
    curl -Lo "/tmp/Meslo.zip" "$FONT_URL"
    unzip -o "/tmp/Meslo.zip" -d "$FONT_DIR"
    echo "Installed Nerd Font: $FONT_NAME"
else
    echo "Nerd Font: $FONT_NAME already installed!"
fi

# Configure VS Code terminal to use Nerd Font
echo "Configuring Visual Studio Code terminal to use Nerd Font..."
SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" >"$SETTINGS_FILE"
fi

if ! grep -q "terminal.integrated.fontFamily" "$SETTINGS_FILE"; then
    sed -i '' 's/^{$/{\n  "terminal.integrated.fontFamily": "MesloLGS NF",/' "$SETTINGS_FILE"
else
    sed -i '' 's/"terminal.integrated.fontFamily": ".*"/"terminal.integrated.fontFamily": "MesloLGS NF"/' "$SETTINGS_FILE"
fi

# Reload Zsh to apply changes
source ~/.zshrc

# Configure Powerlevel10k
echo "Configuring Powerlevel10k..."
p10k configure

# Install Node.js packages
echo "Installing global Node.js packages..."
npm install -g yarn eslint prettier

# Install VS Code extensions
echo "Installing VS Code extensions..."
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension eamodio.gitlens

# Clean up
echo "Cleaning up..."
brew cleanup

echo "Setup complete! Restart your terminal for changes to take effect."
