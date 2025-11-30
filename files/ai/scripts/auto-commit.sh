#!/bin/bash

# Claude Code Stop Hook: Auto-commit
# Claudeの作業完了時に変更があればClaudeに指示してコミットを作成
#
# 機能:
# - Stop Hookとして動作し、Claudeの作業完了時に自動トリガー
# - ループ防止チェック（stop_hook_activeフラグの確認）
# - Gitリポジトリの検証
# - 共通スクリプト（generate-commit-prompt.sh）を呼び出してコミット支援プロンプトを生成
# - JSON形式で"block"決定を返し、Claudeにコミット作成を指示
#
# 注: ブランチ検証、変更検出、分割コミット推奨などの詳細な機能は
#     共通スクリプト（~/.claude/scripts/generate-commit-prompt.sh）に実装されています

set -eu

# ========================================
# SECTION 1: Input and Loop Prevention
# ========================================

# stdinからJSON入力を読み取る
INPUT=$(cat)

# ループ防止: stop_hook_activeがtrueの場合は即座に終了
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

# ========================================
# SECTION 2: Git Repository Validation
# ========================================

# Gitリポジトリかどうかを確認. そうでない場合は終了
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# ========================================
# SECTION 3: Generate Commit Prompt
# ========================================

# 共通スクリプトのパスを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATE_PROMPT_SCRIPT="$SCRIPT_DIR/generate-commit-prompt.sh"

# 共通スクリプトを実行してプロンプトを生成
if ! PROMPT=$("$GENERATE_PROMPT_SCRIPT" 2>&1); then
  # エラーが発生した場合は静かに終了（変更なし、またはエラー）
  exit 0
fi

# プロンプトにStop Hook用の追記を追加
MESSAGE=$(cat <<EOF
$PROMPT

このメッセージはStop Hookから送信されています。
EOF
)

# ========================================
# SECTION 4: JSON Response
# ========================================

# 変更がある場合：JSON応答でClaudeに指示を返す
# jq -Rs . を使用してMESSAGEを適切にエスケープ
cat <<EOF
{
  "decision": "block",
  "reason": $(echo "$MESSAGE" | jq -Rs .)
}
EOF

exit 0
