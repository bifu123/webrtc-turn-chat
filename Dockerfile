FROM python:3.11-slim

WORKDIR /app

COPY signaling_server.py .

RUN pip install websockets

CMD ["python", "signaling_server.py"]
