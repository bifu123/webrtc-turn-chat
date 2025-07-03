#!/bin/bash

# 项目路径，包含 git 仓库和 docker-compose.yml
PROJECT_DIR="/home/test/webrtc-turn-chat"

# 进入项目目录
cd "$PROJECT_DIR" || { echo "目录不存在"; exit 1; }

# 1. 拉取远程最新代码
git fetch origin

# 2. 比较本地 HEAD 与 origin/master 是否相同
LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/master)

if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo "检测到远程仓库有更新，开始拉取最新代码..."
    git pull origin master

    echo "停止并删除旧容器..."
    docker-compose down

    echo "重新构建并启动容器..."
    docker-compose up --build -d

    echo "更新完成，服务已重启。"
else
    echo "无更新，保持现状。"
fi
