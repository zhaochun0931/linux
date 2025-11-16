import socket

UDP_IP = "0.0.0.0"
UDP_PORT = 5005

# Create UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

# Print server info
print(f"UDP server listening on port {UDP_PORT} (all interfaces)")

while True:
    # Receive message
    data, addr = sock.recvfrom(1024)  # addr = (client_ip, client_port)
    client_ip, client_port = addr

    print(f"Received from client {client_ip}:{client_port} on server port {UDP_PORT}: {data.decode()}")

    # Echo back to client
    sock.sendto(data, addr)
    print(f"Sent echo back to client {client_ip}:{client_port}")

