# Devcontainer Dotfiles

This repository contains the dotfiles for my devcontainer setup. While you can clone this as is and use it, it is intended to be a starting point that others can use to bootstrap their own, custom config.

## Usage

For Devcontainers to pick up your dotfiles, place your config folder somewhere and export `DOTFILES_DIR` to that location. For example, I have mine in `~/.devcontainer`, and set up with:
```sh
echo 'export DOTFILES_DIR=${HOME}/.devcontainer' >> ~/.zshrc
source ~/.zshrc
```
> See the `.devcontainer/README.md` in a repository that has a devcontainer setup for more detailed information, or use the `bootstrap_devc` script to add one to a repo that has not been set up yet.

To switch shells, prefix the desired rc file (`bashrc` or `zshrc`) with a `.`, and remove the prefix from the other:
```sh
# E.g., move from /bin/zsh to /bin/bash
mv .zshrc zshrc
mv bashrc .bashrc
```
> Renaming the files to anything else will disable them, but will break the `.gitignore` rules.

## Note

One or two things you will likely want to have are files for aliases and/or environment variables. To make this repo public, those are `.gitignore`'d her and you will need to create them yourself.

If using my `start.sh`, name them `aliases` and/or `envs`, respectively. The script will prefix them with `.$(basename $SHELL)_`, and they will be sourced when the shell's rc file is read.
