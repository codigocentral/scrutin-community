#!/usr/bin/env bash
#
# Scrutin Community — Installer (Linux / macOS)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/codigocentral/scrutin-community/main/install.sh | bash
#
# Env vars (optional):
#   SCRUTIN_COMMUNITY_VERSION   version to install (e.g. community-v0.1.5). Default: latest
#   SCRUTIN_INSTALL_DIR         install directory. Default: /usr/local/bin or ~/.local/bin
#

set -euo pipefail

REPO="codigocentral/scrutin-community"
BINARY="scrutin-community"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[ OK ]${NC}  $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
err()   { echo -e "${RED}[ERR ]${NC}  $1" >&2; exit 1; }
step()  { echo -e "\n${BOLD}▶ $1${NC}"; }

detect_platform() {
    local os arch
    case "$(uname -s)" in
        Linux)  os="linux"  ;;
        Darwin) os="darwin" ;;
        *)      err "Unsupported OS: $(uname -s). Download manually from https://github.com/${REPO}/releases" ;;
    esac
    case "$(uname -m)" in
        x86_64|amd64)  arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        *)             err "Unsupported arch: $(uname -m)" ;;
    esac
    echo "${os}-${arch}"
}

step "Scrutin Community Installer"

PLATFORM=$(detect_platform)
info "Platform: ${PLATFORM}"

step "Fetching latest version"
if [ -n "${SCRUTIN_COMMUNITY_VERSION:-}" ]; then
    VERSION="${SCRUTIN_COMMUNITY_VERSION}"
else
    VERSION=$(curl -sf "https://api.github.com/repos/${REPO}/releases/latest" \
        | grep '"tag_name"' | sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/' | head -1)
    [ -z "$VERSION" ] && err "Could not fetch latest version. Try setting SCRUTIN_COMMUNITY_VERSION."
fi
info "Version: ${VERSION}"

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${BINARY}-${PLATFORM}"

step "Downloading ${BINARY} ${VERSION} for ${PLATFORM}"
info "URL: ${DOWNLOAD_URL}"

TMP=$(mktemp)
trap "rm -f $TMP" EXIT

curl -fL --progress-bar -o "$TMP" "$DOWNLOAD_URL" \
    || err "Download failed. Check https://github.com/${REPO}/releases for available binaries."

chmod +x "$TMP"

step "Installing"

if [ -n "${SCRUTIN_INSTALL_DIR:-}" ]; then
    INSTALL_DIR="${SCRUTIN_INSTALL_DIR}"
elif [ -w /usr/local/bin ]; then
    INSTALL_DIR=/usr/local/bin
else
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

mv "$TMP" "${INSTALL_DIR}/${BINARY}"

ok "${BINARY} installed to ${INSTALL_DIR}/${BINARY}"

# Check PATH
if ! command -v "$BINARY" &>/dev/null; then
    warn "Add ${INSTALL_DIR} to your PATH:"
    warn "  export PATH=\"\$PATH:${INSTALL_DIR}\""
fi

echo ""
echo -e "${BOLD}Try it:${NC}"
echo "  ${BINARY} local ."
echo "  ${BINARY} rules"
echo "  ${BINARY} --help"
echo ""
echo -e "${BOLD}Want AI-powered PR review (GitHub, GitLab, Azure DevOps)?${NC}"
echo "  → https://scrutin.dev  (from \$19/user/month)"
echo ""
