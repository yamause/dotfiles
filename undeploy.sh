#!/usr/bin/env bash

set -eu

BASE_DIR=$(realpath "$(dirname "$0")")
DOTFILES="$BASE_DIR/files"
FILE_LIST="$BASE_DIR/filelist.txt"
BACKUP_BASE_DIR="$BASE_DIR/backup"
BACKUP_DIR="$BACKUP_BASE_DIR/$(date +%Y%m%d_%H%M%S)"

while read -r LINE; do

    FILE_PATH="$DOTFILES"/$(echo "$LINE" | cut -d: -f1)

    # ~で始まるパスを$HOMEで置換
    DEST_PATH=$(echo "$LINE" | cut -d: -f2 | sed "s|^~|$HOME|")

    # シンボリックリンクを削除
    if [ "$(realpath "$FILE_PATH")" == "$(realpath "$DEST_PATH")" ]; then
        # バックアップディレクトリの作成
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
        fi

        # バックアップディレクトリに.gitignoreがなければ作成
        if [ ! -e "$BACKUP_BASE_DIR/.gitignore" ]; then
            echo -e "# Automatically created by dotfiles.\n*" > "$BACKUP_BASE_DIR/.gitignore"
        fi

        cp -r "$DEST_PATH" "$BACKUP_DIR/$(basename "$DEST_PATH").bk"
        echo "Backup: $DEST_PATH to $BACKUP_DIR/$(basename "$DEST_PATH").bk"

        unlink "$DEST_PATH"
        echo "Unlink: $DEST_PATH"

        # bashrcを削除する場合、その後/etc/skelからコピーする
        if [ "$DEST_PATH" == "$HOME/.bashrc" ] && [ ! -e "$HOME/.bashrc" ] && [ -e "/etc/skel/.bashrc" ]; then
            cp "/etc/skel/.bashrc" "$HOME/.bashrc"
            echo "Copy: /etc/skel/.bashrc to $HOME/.bashrc"
        fi
    fi
done < "$FILE_LIST"
