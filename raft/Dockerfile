# Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN pip install flask requests

CMD ["python", "raft.py"]
