#!/bin/bash

# 自动比较本地与远程仓库代码，如果有更新，自动拉取、重启容器

PROJECT_DIR="/home/test/webrtc-turn-chat"

cd "$PROJECT_DIR" || { echo "目录不存在"; exit 1; }

# 拉取远程更新
git fetch origin

# 获取本地和远程最新提交哈希
LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/main)

if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo "检测到远程仓库有更新，开始拉取最新代码..."
    git pull origin main

    echo "停止并删除旧容器..."
    docker-compose down

    echo "重新构建并启动容器..."
    docker-compose up --build -d

    echo "更新完成，服务已重启。"
else
    echo "无更新，保持现状。"
fi
