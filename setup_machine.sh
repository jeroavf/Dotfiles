#!/usr/bin/env bash

readonly dotfiles_dir="$HOME/Dotfiles"
readonly dotfiles_repo='https://github.com/c-w/Dotfiles.git'
readonly docker_compose_version='1.24.0'
readonly nvm_version='v0.34.0'

main() {
    sudo apt-get update
    sudo apt-get upgrade -y

    # systems stuff
    sudo apt-get install -y \
        man \
        curl \
        jq \
        htop \
        software-properties-common \
        aspell-en

    # development stuff
    sudo apt-get install -y \
        build-essential \
        git \
        tmux \
        vim \
        cloc

    # python stuff
    sudo apt-get install -y \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv

    # docker
    curl -fsSL https://get.docker.com | sudo bash -
    sudo usermod -aG docker "$USER"
    sudo curl -fsSL "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # node
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | bash
    export NVM_DIR="$HOME/.nvm"
    . "$NVM_DIR/nvm.sh"
    nvm install --lts

    # editors
    sudo snap install code --classic

    # browsers
    wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo dpkg -i "google-chrome-stable_current_amd64.deb"
    rm "google-chrome-stable_current_amd64.deb"

    # setup dot-files
    [ ! -d "${dotfiles_dir}" ] && git clone --recursive "${dotfiles_repo}" "${dotfiles_dir}"
    find "${dotfiles_dir}" \( \
            -name ".*" -and \
            -not -wholename "*.git/*" -and \
            -not -name "*.git" -and \
            -not -name "*.gitignore" -and \
            -not -name "*.gitmodules" \) \
        -exec ln -f -s {} ~/ \;
}

main
