import socket

SERVER_IP = "server"  # or server container name in Docker
SERVER_PORT = 5005
MESSAGE = "Hello from client!"

# Create UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind to an ephemeral port (let OS choose)
sock.bind(('', 0))  # '' means any local interface, 0 means any free port

client_ip, client_port = sock.getsockname()
print(f"Client sending from {client_ip}:{client_port} to {SERVER_IP}:{SERVER_PORT}")

# Send message to server
sock.sendto(MESSAGE.encode(), (SERVER_IP, SERVER_PORT))

# Receive echo from server
data, addr = sock.recvfrom(1024)
print(f"Received echo from server {addr[0]}:{addr[1]}: {data.decode()}")

sock.close()

