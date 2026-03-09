# Scrutin Community

> **Static code analysis CLI for developers — no AI required, no account needed.**

Scrutin Community is the open-source static analysis engine that powers [Scrutin](https://scrutin.dev). It finds real bugs, security vulnerabilities, and code smells in your code using 900+ rules across all major languages — locally, instantly, for free.

```bash
curl -fsSL https://get.scrutin.dev/agent | bash
scrutin analyze .
```

---

## What it finds

| Category | Examples |
|----------|----------|
| **Security** | SQL injection, XSS, hardcoded secrets, path traversal |
| **Bugs** | Null dereference, unchecked errors, race conditions |
| **Code Smells** | Cognitive complexity, duplicated code, dead code |
| **OWASP Top 10** | Full coverage mapped to CWE |
| **Dependencies** | Known vulnerable packages (SCA) |

Supports: **TypeScript · JavaScript · Python · Java · C# · Go · Rust · PHP · Ruby · Kotlin · Swift · C/C++ · and more**

---

## Install

```bash
# Linux / macOS
curl -fsSL https://get.scrutin.dev/agent | bash

# Windows (PowerShell)
iwr -useb https://get.scrutin.dev/agent.ps1 | iex

# Or download directly
# https://github.com/codigocentral/scrutin-community/releases
```

---

## Usage

```bash
# Analyze current directory
scrutin analyze .

# Analyze a specific path
scrutin analyze ./src

# Show all available rules
scrutin rules

# Output as JSON (CI-friendly)
scrutin analyze . --output json

# Save report to file
scrutin analyze . --output-file report.json

# Health check
scrutin doctor
```

---

## Example output

```
scrutin analyze .

✓ Analyzed 147 files in 1.2s

CRITICAL  src/auth/login.ts:42
  SQL injection — user input concatenated directly into query
  CWE-89 · OWASP A03:2021

HIGH      src/api/upload.ts:118
  Path traversal — filename not sanitized before file.write()
  CWE-22 · OWASP A01:2021

MEDIUM    src/utils/cache.ts:67
  Potential null dereference — result used without null check

─────────────────────────────────────────
  3 issues found  (1 critical · 1 high · 1 medium)

💡 Want AI-powered analysis + automatic PR review?
   → https://scrutin.dev  (free to start)
```

---

## What's included

| Feature | Community | [Scrutin Agent](https://scrutin.dev) |
|---------|:---------:|:--------------------:|
| Static analysis (900+ rules) | ✅ | ✅ |
| All languages | ✅ | ✅ |
| OWASP / CWE mapping | ✅ | ✅ |
| Dependency scanning (SCA) | ✅ | ✅ |
| JSON / CI output | ✅ | ✅ |
| **AI-powered review** | ❌ | ✅ |
| **Automatic PR review** | ❌ | ✅ |
| **GitHub / GitLab / Azure integration** | ❌ | ✅ |
| **Team dashboard** | ❌ | ✅ |
| **BYOK (Bring Your Own Key)** | ❌ | ✅ |

---

## CI/CD integration

**GitHub Actions:**
```yaml
- name: Scrutin Analysis
  run: |
    curl -fsSL https://get.scrutin.dev/agent | bash
    scrutin analyze . --output json --output-file scrutin-report.json
```

**GitLab CI:**
```yaml
scrutin:
  script:
    - curl -fsSL https://get.scrutin.dev/agent | bash
    - scrutin analyze . --output json
```

---

## Rules

Scrutin Community ships with **900+ rules** based on:

- [SonarSource rules](https://rules.sonarsource.com/) (adapted)
- OWASP Top 10 (2021)
- CWE Top 25
- Language-specific best practices

Rules are embedded in the binary — no network required after install.

---

## License

Apache 2.0 — see [LICENSE](LICENSE)

---

## Upgrade to Scrutin Agent

Scrutin Community runs locally. **[Scrutin Agent](https://scrutin.dev)** connects to your Git provider and reviews every PR automatically — with AI, as part of your team's workflow.

- Automatic review on every PR — no manual runs
- AI that finds what static analysis misses
- Team dashboard with trends and metrics
- GitHub, GitLab, Azure DevOps native integration

**[Get started free → scrutin.dev](https://scrutin.dev)**
