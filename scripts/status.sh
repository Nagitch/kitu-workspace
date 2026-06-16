#!/usr/bin/env sh
set -eu

git status --short
printf '\n[submodules]\n'
git submodule status --recursive
printf '\n[child repository status]\n'
git submodule foreach --recursive 'printf "\n%s\n" "$name"; git status --short'
