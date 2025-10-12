import socket
import time

HOST = 'server'  # service name in Docker Compose
PORT = 12345

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    time.sleep(3)  # wait for server to start
    s.connect((HOST, PORT))
    for i in range(5):
        msg = f"Hello {i}"
        print("Sending:", msg)
        s.sendall(msg.encode())
        data = s.recv(1024)
        print("Received:", data.decode())
        time.sleep(1)
