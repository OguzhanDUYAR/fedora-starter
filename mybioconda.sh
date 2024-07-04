#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}
# Display welcome message
echo "#############################################################"
echo "#                                                           #"
echo "#          Welcome to Anaconda 2024.06 Setup For Linux      #"
echo "#                 github.com/OguzhanDUYAR                   #"
echo "#############################################################"
# Download and install Anaconda
ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh"
INSTALLER="Anaconda3-2024.06-1-Linux-x86_64.sh"

if ! command_exists conda; then
    echo "Downloading Anaconda installer..."
    curl -O $ANACONDA_URL

    echo "Installing Anaconda..."
    bash $INSTALLER -b -p $HOME/anaconda3

    echo "Cleaning up installer..."
    rm $INSTALLER
else
    echo "Anaconda is already installed."
fi

# Add Anaconda to PATH in .bashrc and .zshrc
if [ -f "$HOME/.bashrc" ]; then
    grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

if [ -f "$HOME/.zshrc" ]; then
    grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Source .bashrc or .zshrc
if [ -n "$BASH_VERSION" ]; then
    source "$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    source "$HOME/.zshrc"
fi

# Create .desktop file for Anaconda Navigator
DESKTOP_FILE="$HOME/.local/share/applications/anaconda-navigator.desktop"
mkdir -p "$(dirname $DESKTOP_FILE)"

echo "[Desktop Entry]
Name=Anaconda Navigator
Comment=Launch Anaconda Navigator
Exec=$HOME/anaconda3/bin/anaconda-navigator
Icon=$HOME/anaconda3/lib/python3.8/site-packages/anaconda_navigator/static/images/anaconda-icon-256x256.png
Terminal=false
Type=Application
Categories=Development;Education;Science;" > "$DESKTOP_FILE"

echo "Anaconda Navigator .desktop file created."

# Update all conda packages
echo "Updating all conda packages..."
$HOME/anaconda3/bin/conda update --all -y

# Create conda environment named mybio with Python 3.10
echo "Creating conda environment 'mybio' with Python 3.10..."
$HOME/anaconda3/bin/conda create -n mybio python=3.10 -y

# Activate mybio environment
source $HOME/anaconda3/bin/activate mybio

# Install specified packages
echo "Installing packages in the 'mybio' environment..."
$HOME/anaconda3/bin/conda install -n mybio -c conda-forge bioconda -y
$HOME/anaconda3/bin/conda install -n mybio numpy pandas spyder biopy anaconda-navigator -y


# Add command to activate 'mybio' environment by default in .bashrc and .zshrc
ACTIVATE_CMD='conda activate mybio'

if [ -f "$HOME/.bashrc" ]; then
    grep -qxF "$ACTIVATE_CMD" "$HOME/.bashrc" || echo "$ACTIVATE_CMD" >> "$HOME/.bashrc"
fi

if [ -f "$HOME/.zshrc" ]; then
    grep -qxF "$ACTIVATE_CMD" "$HOME/.zshrc" || echo "$ACTIVATE_CMD" >> "$HOME/.zshrc"
fi

echo "Anaconda setup and configuration completed successfully."
anaconda-navigator

