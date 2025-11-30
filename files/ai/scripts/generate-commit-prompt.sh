#!/bin/bash

# ========================================
# Commit Prompt Generator
# ========================================
# Git変更を分析してコミット支援プロンプトを生成する共通スクリプト
#
# 使用元:
#   - Stop Hook (~/.claude/hooks/stop.sh -> files/ai/scripts/auto-commit.sh)
#   - スラッシュコマンド (~/.claude/commands/commit.md)
#
# 使用方法:
#   ./generate-commit-prompt.sh
#
# 出力:
#   標準出力: コミット支援プロンプトテキスト
#   標準エラー出力: エラーメッセージ
#
# 終了コード:
#   0: 成功（変更あり、プロンプト生成完了）
#   1: エラー（変更なし、またはGitエラー）

set -eu

# ========================================
# Repository Validation
# ========================================

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "エラー: Gitリポジトリではありません。" >&2
  exit 1
fi

# ========================================
# Change Detection
# ========================================

# 変更を検出
if ! CHANGES=$(git status --porcelain 2>&1); then
  echo "git status の実行に失敗しました。" >&2
  echo "エラー: $CHANGES" >&2
  exit 1
fi

# 変更がない場合は終了
if [ -z "$CHANGES" ]; then
  echo "変更が検出されませんでした。" >&2
  exit 1
fi

# ========================================
# Branch Analysis
# ========================================

# 現在のブランチ名を取得
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# detached HEAD状態の検出
if [ -z "$CURRENT_BRANCH" ] || [ "$CURRENT_BRANCH" = "HEAD" ]; then
  echo "detached HEAD状態またはブランチ情報の取得に失敗しました。" >&2
  echo "先にブランチをチェックアウトしてから作業を続けてください。" >&2
  echo "例: git checkout -b feature/new-work" >&2
  exit 1
fi

# 保護ブランチ（main/master）への警告メッセージ生成
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
  BRANCH_WARNING="⚠️  警告: 現在 '$CURRENT_BRANCH' ブランチにいます。
   保護されたブランチへの直接コミットは推奨されません。
   適切なブランチを作成することを強く推奨します。

"
else
  BRANCH_WARNING=""
fi

# ========================================
# Diff Summary Generation
# ========================================

# 差分統計を取得
DIFF_SUMMARY=$(git diff --stat 2>/dev/null || echo "")
DIFF_SUMMARY_STAGED=$(git diff --cached --stat 2>/dev/null || echo "")

# 変更ファイル数をカウント
CHANGED_FILES_COUNT=$(echo "$CHANGES" | wc -l)

# ========================================
# Split Commit Suggestion
# ========================================

# 10ファイル以上の変更がある場合、分割コミットを推奨
if [ "$CHANGED_FILES_COUNT" -ge 10 ]; then
  SPLIT_COMMIT_SUGGESTION="

📋 変更範囲が大きいため、以下のように分割コミットを推奨します：
   1. 関連する変更をグループ化して分析
   2. 機能ごと、ファイル種別ごと、または論理的なまとまりで複数回に分けてコミット
   3. 各コミットは独立して意味を持つようにする

   例：
   - git add src/components/ && git commit -m \"feat: コンポーネントを更新\"
   - git add tests/ && git commit -m \"test: テストを追加\"
   - git add docs/ && git commit -m \"docs: ドキュメントを更新\"
"
else
  SPLIT_COMMIT_SUGGESTION=""
fi

# ========================================
# Diff Summary Consolidation
# ========================================

# ステージング済みと未ステージングの差分統計を統合
FULL_DIFF_SUMMARY=""

# ステージング済み変更の追加
if [ -n "$DIFF_SUMMARY_STAGED" ]; then
  FULL_DIFF_SUMMARY="【ステージング済み変更】
$DIFF_SUMMARY_STAGED"
fi

# 未ステージング変更の追加
if [ -n "$DIFF_SUMMARY" ]; then
  [ -n "$FULL_DIFF_SUMMARY" ] && FULL_DIFF_SUMMARY="$FULL_DIFF_SUMMARY

"
  FULL_DIFF_SUMMARY="${FULL_DIFF_SUMMARY}【未ステージング変更】
$DIFF_SUMMARY"
fi

# ========================================
# Prompt Output
# ========================================

cat <<EOF
変更が検出されました。

${BRANCH_WARNING}【現在のブランチ】
$CURRENT_BRANCH

【変更ファイル数】
$CHANGED_FILES_COUNT ファイル

【変更ファイル】
$CHANGES

$FULL_DIFF_SUMMARY

以下の手順でGit操作を実行してください：

1. 変更内容を確認
   - git status で変更ファイルを確認
   - git diff で変更内容の詳細を確認

2. ブランチの妥当性を判断
   - 変更内容が現在のブランチ名「$CURRENT_BRANCH」に適合するか分析
   - 適合する場合：ステップ3へ進む
   - 適合しない場合：
     a. 変更内容を分析し、Conventional Commitsのタイプに基づいて適切なブランチ名を日本語で提案
        - feat: 新機能 → feature/xxx
        - fix: バグ修正 → fix/xxx
        - docs: ドキュメント → docs/xxx
        - style: コードスタイル → style/xxx
        - refactor: リファクタリング → refactor/xxx
        - perf: パフォーマンス改善 → perf/xxx
        - test: テスト追加・修正 → test/xxx
        - chore: ビルド・補助ツール → chore/xxx
     b. git checkout -b [タイプ]/[説明] で新ブランチを作成
     c. ステップ3へ進む

3. 変更をコミット${SPLIT_COMMIT_SUGGESTION}
   - 変更範囲に応じて適切にファイルをステージング（git add）
   - 変更内容を分析し日本語で、Conventional Commitsに従い適切なコミットメッセージを作成してコミット
     - タイプ: feat, fix, docs, style, refactor, perf, test, chore
   - 複数のコミットが必要な場合は、各コミットが独立して意味を持つように分割
EOF

exit 0
