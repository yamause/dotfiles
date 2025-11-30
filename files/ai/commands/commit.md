---
description: Git変更を分析してコミット作成を支援
---

```bash
#!/bin/bash

# スラッシュコマンド: /commit
# Git変更を分析してコミット作成を支援する

set -eu

# 共通スクリプトのパスを取得（~/.claude/scripts/ 配下を想定）
SCRIPT_DIR="$HOME/.claude/scripts"
GENERATE_PROMPT_SCRIPT="$SCRIPT_DIR/generate-commit-prompt.sh"

# 共通スクリプトの存在確認
if [ ! -f "$GENERATE_PROMPT_SCRIPT" ]; then
  echo "エラー: 共通スクリプトが見つかりません: $GENERATE_PROMPT_SCRIPT"
  exit 1
fi

# 共通スクリプトを実行してプロンプトを生成
if ! "$GENERATE_PROMPT_SCRIPT"; then
  exit 1
fi
```
