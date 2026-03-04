import socket
import os

socket_path = "/tmp/python_unix_socket"

# Clean up the socket file if it already exists
if os.path.exists(socket_path):
    os.remove(socket_path)

# Create a Unix Domain Socket (AF_UNIX)
server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(socket_path)
server.listen(1)

print(f"Server listening on {socket_path}...")

while True:
    connection, address = server.accept()
    try:
        data = connection.recv(1024)
        if data:
            print(f"Received: {data.decode()}")
            connection.sendall(b"Message received by server!")
    finally:
        connection.close()
