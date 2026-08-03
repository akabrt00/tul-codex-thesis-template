# Native command recipes

Use only commands available on the current system. Quote all paths.

## Calculate SHA-256

- PowerShell: `Get-FileHash -Algorithm SHA256 -LiteralPath <path>`
- macOS: `shasum -a 256 <path>`
- Linux: `sha256sum <path>`
- Python fallback: `python -c` with `hashlib.sha256`, only when Python is already available

## Inspect the registry and files

- Prefer `rg` or `rg --files` when available.
- PowerShell fallback: `Get-ChildItem -Recurse -File` and `Select-String`.
- POSIX fallback: `find` and `grep`.

Run read-only duplicate and path checks before proposing moves or renames. Never build destructive commands from unverified search output.
