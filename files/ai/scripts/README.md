# Claude Code Helper Scripts

このディレクトリには、Claude Codeの動作を補助する自動化スクリプトが含まれています。

## スクリプト一覧

### check-branch.sh

main/masterブランチへの直接コミットを防止します。

**実行タイミング**: `git commit`コマンド実行前（PreToolUse hook）

**動作**:

- 現在のブランチがmain/masterの場合、警告を表示してコミットをブロック
- それ以外のブランチでは何もせずに成功を返す

### init-work-journal.sh

作業ジャーナルディレクトリを自動初期化します。

**実行タイミング**: セッション開始時（SessionStart hook）

**動作**:

- `./work-journal`ディレクトリが存在しない場合、作成して`.gitignore`を配置
- 既存のジャーナルファイルがある場合、その数を通知

### rotate-logs.sh

コマンド履歴ログのローテーションを行います。

**実行タイミング**: Bashコマンド実行前（PreToolUse hook）

**動作**:

- `~/.claude/command_history.log`が10MBを超えた場合、タイムスタンプ付きでローテート
- 古いログファイルは最新5件のみ保持

## 設定ファイルとの連携

これらのスクリプトは `~/.claude/settings.json` の hooks 設定から自動的に呼び出されます。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.command | select(test(\"^git commit\"))' | grep -q . && ~/.claude/scripts/check-branch.sh || true"
          },
          {
            "type": "command",
            "command": "~/.claude/scripts/rotate-logs.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/scripts/init-work-journal.sh \"$(pwd)\""
          }
        ]
      }
    ]
  }
}
```

## カスタマイズ

各スクリプトは独立して動作するため、個別に無効化・カスタマイズが可能です。

例: ログローテーションのサイズ制限を変更する場合

```bash
# rotate-logs.sh の MAX_SIZE_MB 変数を編集
MAX_SIZE_MB=20  # 10MB → 20MB に変更
```
