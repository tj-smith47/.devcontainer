#!/bin/bash
# Modified from: https://github.com/thomaspttn/nvim-docker/blob/main/install.sh
# FILE: install.sh
# DESCRIPTION: Master setup script for nvim-docker
# AUTHOR: Thomas Patton
# shellcheck disable=SC1091

## ENV's
INSTALL_DIR="${HOME:-/home/salesloft}/"
NODE_VERSION="20.14.0"
NVIM_CONFIG_REPO="$1"
NVIM_VERSION="v0.10.1"
NVM_VERSION="v0.39.7"

ARCH=$(uname -m)
if [ "${ARCH}" == "x86_64" ] || [ "${ARCH}" == "amd64" ]; then
  DOWNLOAD_FILE="nvim-linux64.tar.gz"
  NVIM_FILE="nvim-linux64/bin/nvim"
  ARCH="amd64"
else
  DOWNLOAD_FILE="nvim.appimage"
  NVIM_FILE="nvim.appimage"
  ARCH="arm64"
fi

GREEN="\033[0;32m"
NC="\033[0m"

# Update XDG_CONFIG_HOME
export XDG_CONFIG_HOME="${INSTALL_DIR}.config"
export XDG_DATA_HOME="${INSTALL_DIR}.local/share"
export XDG_STATE_HOME="${INSTALL_DIR}.local/state"
export TERM="xterm-256color"
export DISPLAY=":0"

## Functions
setup() {
  sudo apt-get update
  sudo apt-get install -y bear clang python3-venv ripgrep xclip
  sudo ln -s -f .clangd ~/.clangd
}

install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
  export NVM_DIR="$INSTALL_DIR.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  nvm install ${NODE_VERSION}
}

install_nvim() {
  wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${DOWNLOAD_FILE}"
  [[ "${ARCH}" != "arm64" ]] && tar -xzvf "${DOWNLOAD_FILE}"
  chmod u+x "${NVIM_FILE}"
  sudo ln -s "${INSTALL_DIR}${NVIM_FILE}" /usr/local/bin/nvim
}

clone_repo() {
  # Git Repository (provided as an argument)
  if [ -n "$1" ]; then
    git clone "$1" "${INSTALL_DIR}.config/nvim"
  else
    echo "Git repository URL not provided, proceeding without"
  fi
}

## Main
cd "$INSTALL_DIR" || exit
echo -e "\n========== ${GREEN}Running Docker container setup...${NC} ==========\n"

setup
install_nvm
install_nvim
install_rg
clone_repo "${NVIM_CONFIG_REPO}"

echo -e "\n========== ${GREEN}Setup complete!${NC} ==========\n"
cd - || exit
