#!/usr/bin/env bash
# shellcheck disable=SC1091

sudo apt-get update -qq
sudo apt-get install -qqy vim ruby-dev curl fuse make

sudo gem install colorls

# Install nvim / clone config
cd "${HOME}" || exit
[[ ! -d "${HOME}/.local/bin" ]] && mkdir -p "${HOME}/.local/bin"
git clone https://github.com/thomaspttn/nvim-docker.git "${HOME}/nvim-docker/"
INSTALL_DIR="${HOME}" source "${HOME}/nvim-docker/install.sh" https://github.com/tj-smith47/nvim.git
cd - || exit

[[ -f "${HOME}/.dotfiles/.zshrc" && ! -f "${HOME}/.dotfiles/.bashrc" ]] &&
    (sudo usermod --shell /usr/bin/zsh salesloft &&
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)

if [ -f "${HOME}/.dotfiles/.bashrc" ]; then
    ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.bash_aliases"
    ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.bash_envs"
    ln -sf "${HOME}/.dotfiles/.bashrc" "${HOME}/.bashrc"
fi

[[ ! -d "${HOME}/.config" ]] && mkdir -p "${HOME}/.config/nvim"
ln -sf "${HOME}/.dotfiles/colorls" "${HOME}/.config/colorls"
ln -sf "${HOME}/.dotfiles/kitty" "${HOME}/.config/kitty"
ln -sf "${HOME}/.dotfiles/dracula-pro.zsh-theme" "${HOME}/.oh-my-zsh/themes/dracula-pro.zsh-theme"
ln -sf "${HOME}/.dotfiles/.p10k.zsh" "${HOME}/.p10k.zsh"
ln -sf "${HOME}/.dotfiles/fzf-git.sh" "${HOME}/fzf-git.sh"

if [ -f "${HOME}/.dotfiles/.zshrc" ]; then
    ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.zsh_aliases"
    ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.zsh_envs"
    ln -sf "${HOME}/.dotfiles/.zshrc" "${HOME}/.zshrc"
fi
