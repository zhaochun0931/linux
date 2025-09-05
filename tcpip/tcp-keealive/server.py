import socket

HOST = "0.0.0.0"
PORT = 5002

def run_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((HOST, PORT))
        s.listen(1)
        print(f"[*] Listening on {HOST}:{PORT}")

        conn, addr = s.accept()
        with conn:
            print(f"[+] Connection from {addr}")
            try:
                while True:
                    data = conn.recv(1024)
                    if not data:
                        print("[!] Client closed connection")
                        break
                    print(f"[Server] Received: {data.decode(errors='ignore')}")
            except Exception as e:
                print(f"[!] Connection error: {e}")

if __name__ == "__main__":
    run_server()
