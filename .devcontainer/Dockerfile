FROM mcr.microsoft.com/devcontainers/rust:1-bookworm

ARG RUST_VERSION=1.96.0
ARG JUST_VERSION=1.57.0

# Common native build and troubleshooting tools used across the submodules.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        clang \
        fzf \
        git \
        libsqlite3-dev \
        libssl-dev \
        lld \
        pkg-config \
        ripgrep \
        zsh \
    && rm -rf /var/lib/apt/lists/*

# Every Rust submodule currently pins the same toolchain.
RUN rustup toolchain install "${RUST_VERSION}" \
        --profile minimal \
        --component clippy,rustfmt \
    && rustup default "${RUST_VERSION}" \
    && cargo install --locked --version "${JUST_VERSION}" just

# Allow the non-root Dev Container user to download Cargo dependencies, while
# keeping workspace-installed binaries separate from the image toolchain.
ENV PATH="/home/vscode/.local/bin:${PATH}"

RUN mkdir -p \
        /home/vscode/.local/bin \
        /usr/local/cargo/registry/cache \
        /usr/local/cargo/registry/index \
        /usr/local/cargo/registry/src \
    && chown -R vscode:rustlang \
        /home/vscode/.local \
        /usr/local/cargo/registry \
    && chmod -R ug+rw /usr/local/cargo/registry
