#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2002,SC2094

## ENV's
ARCH=$(uname -m)
SH_NAME=$(basename "${SHELL:-/bin/zsh}")

## Functions
install_deps() {
    sudo apt-get update -qq
    sudo apt-get install -qqy vim ruby-dev curl fuse make
    sudo gem install colorls
}

install_omz() {
    if [ -f "${HOME}/.dotfiles/.zshrc" ] && [ ! -f "${HOME}/.dotfiles/.bashrc" ]; then
        sudo usermod --shell /usr/bin/zsh "$(whoami)"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

install_nvim() {
    # Setup
    cd "${HOME}" || return
    [[ ! -d "${HOME}/.local/bin" ]] && mkdir -p "${HOME}/.local/bin"

    # Clone the nvim setup repo
    git clone https://github.com/thomaspttn/nvim-docker.git "${HOME}/nvim-docker/"

    # Set to container user's home directory instead of root's
    cat <<<"$(cat "${HOME}/nvim-docker/install.sh" | sed "s|/root|${HOME}|g")" >"${HOME}/nvim-docker/install.sh"

    # Update architecture if needed
    [[ "${ARCH}" != "amd64" && "${ARCH}" != "x86_64" ]] && cat <<<"$(cat "${HOME}/nvim-docker/install.sh" | sed "s|amd64|arm64|g")" >"${HOME}/nvim-docker/install.sh"

    # Install nvim
    source "${HOME}/nvim-docker/install.sh" https://github.com/tj-smith47/nvim.git
    cd - || return
}

link_configs() {
    if [ "${SH_NAME}" == "zsh" ]; then
        ln -sf "${HOME}/.dotfiles/dracula-pro.zsh-theme" "${HOME}/.oh-my-zsh/themes/dracula-pro.zsh-theme"
        ln -sf "${HOME}/.dotfiles/.p10k.zsh" "${HOME}/.p10k.zsh"
    fi
    ln -sf "${HOME}/.dotfiles/colorls" "${HOME}/.config/colorls"
    ln -sf "${HOME}/.dotfiles/kitty" "${HOME}/.config/kitty"
    ln -sf "${HOME}/.dotfiles/fzf-git.sh" "${HOME}/fzf-git.sh"
}

setup_shell() {
    if [ -f "${HOME}/.dotfiles/.${SH_NAME}rc" ]; then
        ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.${SH_NAME}_aliases"
        ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.${SH_NAME}_envs"
        ln -sf "${HOME}/.dotfiles/.${SH_NAME}rc" "${HOME}/.${SH_NAME}rc"
    fi
}

## Main
install_deps
install_omz
install_nvim
link_configs
setup_shell
