# Scrutin Community

**Static code analysis. 900+ rules. 10+ languages. No account required.**

Scrutin Community is the free, open-source edition of [Scrutin](https://scrutin.dev) — an AI-powered code review platform. It runs entirely on your machine with no backend connection needed.

## Features

- 900+ static analysis rules (based on SonarQube rule database)
- 10+ languages: JavaScript, TypeScript, Python, Java, C#, Go, Rust, PHP, Ruby, Kotlin, Swift
- OWASP Top 10 and CWE security checks
- Infrastructure as Code (IaC) scanning
- No account, no AI, no internet required
- Single binary — works on Linux, macOS, and Windows

## Quick Install

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/codigocentral/scrutin-community/main/install.sh | bash
```

### Windows (PowerShell)

Download the latest release from the [Releases page](https://github.com/codigocentral/scrutin-community/releases).

### Manual Download

Pre-built binaries for all platforms are available on the [Releases page](https://github.com/codigocentral/scrutin-community/releases).

## Usage

```bash
# Analyze the current directory
scrutin-community local .

# Analyze a specific path
scrutin-community local /path/to/project

# Check system requirements
scrutin-community doctor

# List available rules
scrutin-community rules status

# List rules for a specific language
scrutin-community rules list rust
```

## Available Commands

| Command | Description |
|---------|-------------|
| `local <path>` | Run static analysis on a local directory |
| `doctor` | Check system requirements and diagnostics |
| `rules status` | Show embedded rules status |
| `rules list <lang>` | List analysis rules for a language |
| `rules clean` | Clean rules cache |
| `validate` | Validate project configuration (`.scrutin.yml`) |
| `version` | Show version information |

## Configuration

Create a `.scrutin.yml` (or `.scrutin.toml`, `.scrutin.json`) in your project root to customize analysis:

```yaml
agent:
  max_workers: 4
  log_level: info

analysis:
  exclude:
    - "vendor/**"
    - "node_modules/**"
    - "**/*.min.js"
```

## Want More?

Scrutin Community provides powerful static analysis. For AI-powered analysis, automatic PR reviews, and team features:

| Feature | Community (Free) | Pro ($19/user/mo) | Business ($39/user/mo) |
|---------|:-:|:-:|:-:|
| 900+ static rules | Yes | Yes | Yes |
| AI-powered analysis | - | Yes | Yes |
| Automatic PR review | - | Yes | Yes |
| Custom rules | - | Yes | Yes |
| Quality gates | - | Yes | Yes |
| SSO/SAML | - | - | Yes |
| Azure DevOps | - | - | Yes |

[Get started at scrutin.dev](https://scrutin.dev)

## License

MIT
