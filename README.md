---

## 🐳 webRTC p2p 抗审查聊天系统

本系统是一个轻量级、可一键部署的 WebRTC + TURN 点对点通信示范平台，支持 NAT 穿透失败场景 的中继通信。通过自建 coturn TURN 服务器 和 WebSocket 信令服务，实现局域网内或跨网通信。系统采用 固定用户名+密码认证，无需注册流程，适合教学演示、内网通信、IM 原型开发等。支持 Docker Compose 一键启动，包含网页 UI、信令服务器、TURN 服务，结构清晰、易于扩展，具备良好的可移植性与实际部署价值。

### 📁 项目目录结构（建议放入 GitHub 仓库）

```
webrtc-turn-chat/
├── Dockerfile                # 构建信令服务镜像
├── docker-compose.yml        # 一键启动配置
├── signaling_server.py       # WebSocket 信令服务
├── chat.html                 # WebRTC 聊天页面
├── test_turnserver.html      # TURN 测试页面
├── turnserver/
│   └── turnserver.conf       # TURN 配置（持久化挂载）
└── README.md
```

---

### 🚀 快速部署步骤

必须事先安装了docker、docker-compose

```bash
git clone https://github.com/bifu123/webrtc-turn-chat
cd webrtc-turn-chat
docker-compose up --build -d
```

---

### 🌍 访问方式

- 访问聊天页面：
  ```
  http://<你的本地IP>:8000/chat.html
  ```
- 访问 TURN 测试页面：
  ```
  http://<你的本地IP>:8000/test_turnserver.html
  ```

---

### 📦 docker-compose.yml 示例

```yaml
version: "3.8"
services:
  coturn:
    image: instrumentisto/coturn
    container_name: coturn
    restart: always
    ports:
      - "3478:3478"
      - "3478:3478/udp"
    volumes:
      - ./turnserver/turnserver.conf:/etc/coturn/turnserver.conf
    command: ["-c", "/etc/coturn/turnserver.conf"]

  signaling:
    build: .
    container_name: signaling
    ports:
      - "8765:8765"

  web:
    image: nginx:alpine
    container_name: webui
    ports:
      - "8000:80"
    volumes:
      - .:/usr/share/nginx/html:ro
```

---

### 📄 Dockerfile（信令服务器）

```Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY signaling_server.py .
RUN pip install websockets
CMD ["python", "signaling_server.py"]
```

---

### ✅ 持久化配置说明

- `turnserver.conf` 可根据实际场景修改，使用 `volumes` 挂载后无需每次重建容器
- 页面文件 (`chat.html`, `test_turnserver.html`) 会通过 nginx 自动提供服务

---

### 🛠️ 运行与调试命令

查看日志：
```bash
docker-compose logs -f
```

停止服务：
```bash
docker-compose down
```

---

## 更新方法
在项目目录下运行
```bash
sh ./update_and_restart.sh
```
如果远程git有更改，则会自动拉取，停掉当前容器，重新构建新容器并运行之。

## ✅ 推荐扩展功能

- TURN 使用动态 token（`use-auth-secret` 模式）
- 自动注册用户写入 MySQL 数据库
- 服务暴露为公网服务（需设置 TLS + NAT 映射）
- TURN 服务 + 静态网页 + 信令服务器集成为完整 Docker 镜像

---

本项目支持局域网中构建可靠、无需注册的匿名通信系统，适合教学 / 测试 / 私密聊天原型系统部署。
