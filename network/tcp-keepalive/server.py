import socket

HOST = ""   # Listen on all interfaces
PORT = 12345

print(f"Server starting on port {PORT}...")

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(1)
    print("Server listening for connections...")

    conn, addr = s.accept()
    with conn:
        print(f"Connected by {addr}")
        while True:
            data = conn.recv(1024)
            if not data:
                print("Client disconnected.")
                break
            print(f"Received: {data.decode().strip()}")
