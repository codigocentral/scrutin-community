# Scrutin Community

> **Static code analysis CLI — 900+ rules, 10+ languages, no account required.**

Scrutin Community is the open-source static analysis engine powering [Scrutin](https://scrutin.dev). It finds real bugs, security vulnerabilities, and code smells in your code — **locally, instantly, for free**.

```bash
curl -fsSL https://raw.githubusercontent.com/codigocentral/scrutin-community/main/install.sh | bash
scrutin-community local .
```

---

## Features

- **900+ rules** — SonarQube rule set + OWASP/CWE security rules
- **10+ languages** — C#, TypeScript/JavaScript, Python, Go, Java, Rust, PHP, Kotlin, Ruby, C++
- **IaC scanning** — Dockerfile, Kubernetes, Terraform
- **No account needed** — runs entirely offline
- **No AI required** — pure static analysis
- **Open source** — MIT license

---

## Install

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/codigocentral/scrutin-community/main/install.sh | bash
```

### Windows (PowerShell)

Download from [Releases](https://github.com/codigocentral/scrutin-community/releases/latest) and add to your PATH.

### Manual

Download the binary for your platform from the [Releases page](https://github.com/codigocentral/scrutin-community/releases/latest):

| Platform | Binary |
|----------|--------|
| Linux x86_64 | `scrutin-community-linux-amd64` |
| Linux arm64 | `scrutin-community-linux-arm64` |
| macOS x86_64 | `scrutin-community-darwin-amd64` |
| macOS arm64 (M1/M2/M3) | `scrutin-community-darwin-arm64` |
| Windows x86_64 | `scrutin-community-windows-amd64.exe` |

---

## Usage

```bash
# Analyze current directory
scrutin-community local .

# Analyze specific path
scrutin-community local /path/to/project

# JSON output (for CI/CD)
scrutin-community local . --json

# Show all available rules
scrutin-community rules

# Filter rules by language
scrutin-community rules --language python

# System check
scrutin-community doctor
```

---

## Community vs Scrutin Pro

| Feature | Community | Pro | Business |
|---------|-----------|-----|----------|
| Static analysis (900+ rules) | ✅ | ✅ | ✅ |
| 10+ languages | ✅ | ✅ | ✅ |
| OWASP/CWE security rules | ✅ | ✅ | ✅ |
| IaC scanning | ✅ | ✅ | ✅ |
| AI-powered analysis | ❌ | ✅ | ✅ |
| Automatic PR review | ❌ | ✅ | ✅ |
| GitHub / GitLab / Azure DevOps | ❌ | ✅ | ✅ |
| Dashboard & reports | ❌ | ✅ | ✅ |
| Self-hosted agents | ❌ | ❌ | ✅ |
| SSO / SAML | ❌ | ❌ | ✅ |
| SLA guarantee | ❌ | ❌ | ✅ |
| **Price** | **Free** | **$19/user/mo** | **$39/user/mo** |

**[→ Start free at scrutin.dev](https://scrutin.dev)**

---

## License

MIT — see [LICENSE](LICENSE)

Built by [Código Central](https://github.com/codigocentral) · [scrutin.dev](https://scrutin.dev)
