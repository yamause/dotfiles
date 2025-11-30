---
description: Intelligently categorize and commit all changed files in stages
allowed-tools: [Bash, Read, TodoWrite]
---

# All Commit Command

Analyze all changed files, categorize them intelligently, and create staged commits with appropriate Japanese commit messages.

## Workflow

### 1. Initial Analysis

- Run `git status --porcelain` to get all changed files (new, modified, deleted)
- List all files that will be processed

### 2. File Exclusion

Exclude the following file patterns from commits:

- **Cache files**: `*.cache`, `*.tmp`, `__pycache__/`, `.pytest_cache/`, `node_modules/`, `.next/`, `dist/`, `build/`, `.turbo/`, `.vite/`
- **Secrets**: `.env`, `.env.*`, `*secret*`, `*credential*`, `*token*`, `*.key`, `*.pem`, `id_rsa`, `id_ed25519`, `*.pfx`, `*.p12`
- **Backups**: `*.bak`, `*.backup`, `*~`, `*.swp`, `*.swo`
- **OS files**: `.DS_Store`, `Thumbs.db`, `desktop.ini`
- **Logs**: `*.log` (unless explicitly configuration-related)

If any files are excluded, inform the user with the reason.

### 3. File Categorization

Categorize remaining files into these groups (in commit order):

1. **Config files**: `*.config.*`, `*.rc`, `*.yaml`, `*.yml`, `*.toml`, `*.json`, `*.ini`, `Makefile`, `Dockerfile`, `docker-compose.yml`, `.gitignore`, `.gitattributes`, `pyproject.toml`, `package.json`, `tsconfig.json`, etc.
2. **Documentation**: `*.md`, `*.txt`, `*.rst`, `*.adoc`, files in `docs/` directory
3. **Scripts**: `*.sh`, `*.bash`, `*.zsh`, files in `scripts/` or `bin/` directory
4. **Source code**: `*.py`, `*.js`, `*.ts`, `*.jsx`, `*.tsx`, `*.go`, `*.rs`, `*.java`, `*.c`, `*.cpp`, `*.h`, `*.hpp`, etc.
5. **Tests**: `test_*`, `*_test.*`, `*.test.*`, `*.spec.*`, files in `tests/`, `test/`, `__tests__/` directories
6. **Other**: Any files not matching above categories

### 4. Staged Commits

For each category (in order):

- Skip if no files in category
- Display files to user and ask for confirmation
- Run `git diff` for the files to show changes
- Stage files with `git add`
- Create commit with Japanese message following these rules:
    - Include category name (e.g., "設定ファイルの更新", "ドキュメントの追加")
    - 1-2 sentences focusing on "why" rather than "what"
    - Concise and accurate description of the change intent

### 5. Completion

- Display summary of all commits created
- Show `git log --oneline -n <number_of_commits>` to confirm
- Inform user that all commits are completed

## Example Commit Messages

- "設定ファイルの更新: プロジェクトの依存関係とビルド設定を最新化"
- "ドキュメントの追加: API使用例とセットアップ手順を記載"
- "スクリプトの追加: デプロイメント自動化のためのシェルスクリプトを実装"
- "認証機能の実装: ユーザーログインとトークン管理を追加"
- "テストの追加: 認証フローのユニットテストとE2Eテストを実装"

## Important Notes

- Always use TodoWrite to track progress through the commit stages
- Never commit files containing secrets (warn user if detected)
- Follow the branch creation rule: create a new branch before committing if on main/master
- Each commit represents one logical category of changes
- If git status shows no changes, inform user and exit
