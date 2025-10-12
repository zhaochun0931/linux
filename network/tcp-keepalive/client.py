import socket
import time

HOST = "tcp-server"
PORT = 12345

print(f"Connecting to {HOST}:{PORT}...")
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

# Enable TCP keepalive
s.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
s.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPIDLE, 10)
s.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPINTVL, 5)
s.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPCNT, 3)

print("Connected. Sending message...")
s.sendall(b"Hello from Python client!\n")

print("Now idling to allow keepalive probes to run...")
while True:
    time.sleep(60)
