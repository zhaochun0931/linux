import socket

socket_path = "/tmp/python_unix_socket"

# Create a Unix Domain Socket
client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

try:
    client.connect(socket_path)
    message = "Hello from the Client!"
    client.sendall(message.encode())
    
    # Get the response
    response = client.recv(1024)
    print(f"Server says: {response.decode()}")
finally:
    client.close()
