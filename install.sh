#!/bin/bash
set -euo pipefail

# Scrutin Community — Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/codigocentral/scrutin-community/main/install.sh | bash
#
# Environment variables:
#   SCRUTIN_VERSION      - Specific version to install (default: latest)
#   SCRUTIN_INSTALL_DIR  - Custom install directory

BINARY_NAME="scrutin-community"
REPO="codigocentral/scrutin-community"
GITHUB_API="https://api.github.com"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${CYAN}${BOLD}info${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}  ok${NC} $1"; }
error() { echo -e "${RED}${BOLD}erro${NC} $1" >&2; }
dim() { echo -e "${DIM}$1${NC}"; }

detect_platform() {
    local os arch

    os="$(uname -s)"
    arch="$(uname -m)"

    case "$os" in
        Linux)  os="linux" ;;
        Darwin) os="darwin" ;;
        MINGW*|MSYS*|CYGWIN*) os="windows" ;;
        *) error "OS nao suportado: $os"; exit 1 ;;
    esac

    case "$arch" in
        x86_64|amd64)   arch="amd64" ;;
        aarch64|arm64)   arch="arm64" ;;
        *) error "Arquitetura nao suportada: $arch"; exit 1 ;;
    esac

    PLATFORM="${os}"
    ARCH="${arch}"

    # Binary naming convention from CI
    case "${PLATFORM}_${ARCH}" in
        linux_amd64)  ASSET_NAME="${BINARY_NAME}-linux-amd64" ;;
        linux_arm64)  ASSET_NAME="${BINARY_NAME}-linux-arm64" ;;
        darwin_amd64) ASSET_NAME="${BINARY_NAME}-darwin-amd64" ;;
        darwin_arm64) ASSET_NAME="${BINARY_NAME}-darwin-arm64" ;;
        windows_amd64) ASSET_NAME="${BINARY_NAME}-windows-amd64.exe" ;;
        *) error "Plataforma nao suportada: ${PLATFORM}_${ARCH}"; exit 1 ;;
    esac
}

get_latest_version() {
    local version
    version=$(curl -fsSL "${GITHUB_API}/repos/${REPO}/releases/latest" 2>/dev/null \
        | grep '"tag_name"' \
        | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')

    if [ -z "$version" ]; then
        error "Nao foi possivel obter a versao mais recente do GitHub."
        error "Verifique sua conexao ou defina SCRUTIN_VERSION manualmente."
        exit 1
    fi
    echo "$version"
}

download_and_install() {
    local version="$1"
    local install_dir="$2"
    local tmp_dir

    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    local download_url="https://github.com/${REPO}/releases/download/${version}/${ASSET_NAME}"
    local checksum_url="${download_url}.sha256"

    info "Baixando ${BINARY_NAME} ${version} para ${PLATFORM}/${ARCH}..."
    dim "  ${download_url}"

    if ! curl -fsSL -o "${tmp_dir}/${ASSET_NAME}" "$download_url"; then
        error "Falha ao baixar o binario."
        error "Verifique se a versao ${version} existe para ${PLATFORM}/${ARCH}."
        exit 1
    fi

    # Verify checksum if available
    if curl -fsSL -o "${tmp_dir}/${ASSET_NAME}.sha256" "$checksum_url" 2>/dev/null; then
        info "Verificando checksum SHA256..."
        cd "$tmp_dir"
        if command -v sha256sum &>/dev/null; then
            sha256sum -c "${ASSET_NAME}.sha256" || {
                error "Checksum SHA256 nao confere!"
                exit 1
            }
        elif command -v shasum &>/dev/null; then
            shasum -a 256 -c "${ASSET_NAME}.sha256" || {
                error "Checksum SHA256 nao confere!"
                exit 1
            }
        else
            dim "  (sha256sum nao disponivel, pulando verificacao)"
        fi
        cd - >/dev/null
        success "Checksum verificado"
    else
        dim "  (checksum nao disponivel para esta versao, pulando verificacao)"
    fi

    # Determine install directory
    if [ -z "$install_dir" ]; then
        if [ "$(id -u)" -eq 0 ]; then
            install_dir="/usr/local/bin"
        else
            install_dir="${HOME}/.local/bin"
        fi
    fi

    mkdir -p "$install_dir"

    local target_name="$BINARY_NAME"
    if [ "$PLATFORM" = "windows" ]; then
        target_name="${BINARY_NAME}.exe"
    fi

    info "Instalando em ${install_dir}/${target_name}..."
    cp "${tmp_dir}/${ASSET_NAME}" "${install_dir}/${target_name}"
    chmod +x "${install_dir}/${target_name}"

    success "Instalado com sucesso!"

    # Check if install dir is in PATH
    if ! echo "$PATH" | tr ':' '\n' | grep -qx "$install_dir"; then
        echo ""
        echo -e "${CYAN}${BOLD}Adicione ao seu PATH:${NC}"
        echo ""
        if [ -f "${HOME}/.zshrc" ]; then
            echo "  echo 'export PATH=\"${install_dir}:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
        elif [ -f "${HOME}/.bashrc" ]; then
            echo "  echo 'export PATH=\"${install_dir}:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
        else
            echo "  export PATH=\"${install_dir}:\$PATH\""
        fi
        echo ""
    fi
}

print_next_steps() {
    echo ""
    echo -e "${GREEN}${BOLD}Pronto!${NC} Scrutin Community instalado com sucesso."
    echo ""
    echo -e "${BOLD}Proximo passo:${NC}"
    echo ""
    echo "  ${BINARY_NAME} local .          # Analisa o diretorio atual"
    echo "  ${BINARY_NAME} doctor           # Verifica o sistema"
    echo "  ${BINARY_NAME} rules status     # Mostra regras disponiveis"
    echo ""
    echo -e "${DIM}900+ regras. 10+ linguagens. Sem conta. Sem IA. Open source.${NC}"
    echo ""
    echo -e "${DIM}Quer analise com IA + review automatico de PRs?${NC}"
    echo -e "${DIM}  -> https://scrutin.dev  (a partir de \$19/user/mes)${NC}"
    echo ""
}

main() {
    echo ""
    echo -e "${GREEN}${BOLD}Scrutin Community — Instalador${NC}"
    echo ""

    detect_platform

    local version="${SCRUTIN_VERSION:-}"
    if [ -z "$version" ]; then
        info "Buscando versao mais recente..."
        version=$(get_latest_version)
        success "Versao: ${version}"
    else
        info "Usando versao especificada: ${version}"
    fi

    local install_dir="${SCRUTIN_INSTALL_DIR:-}"

    download_and_install "$version" "$install_dir"
    print_next_steps
}

main "$@"
