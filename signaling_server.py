# signaling_server.py
import asyncio
import websockets
import json

clients = {}

async def handler(ws):
    client_id = None
    try:
        async for message in ws:
            data = json.loads(message)
            if data["type"] == "register":
                client_id = data["id"]
                clients[client_id] = ws
                print(f"🟢 注册: {client_id}")
            else:
                target = data["to"]
                if target in clients:
                    await clients[target].send(json.dumps({**data, "from": client_id}))
    except:
        pass
    finally:
        if client_id:
            del clients[client_id]

async def main():
    print("🚀 信令服务器运行中: ws://0.0.0.0:8765")
    async with websockets.serve(handler, "0.0.0.0", 8765):
        await asyncio.Future()

asyncio.run(main())



