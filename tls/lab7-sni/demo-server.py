import ssl
import socket

# 1. Create the default SSL context
context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.load_cert_chain(certfile="alpha.crt", keyfile="alpha.key") # Default

# 2. Add the SNI mapping for the second site
context_beta = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context_beta.load_cert_chain(certfile="beta.crt", keyfile="beta.key")

def sni_callback(ssl_sock, server_name, initial_context):
    if server_name == "site-beta.com":
        ssl_sock.context = context_beta
    return None

context.sni_callback = sni_callback

# 3. Start the server
bind_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
bind_socket.bind(('127.0.0.1', 8443))
bind_socket.listen(5)

print("Server listening on 127.0.0.1:8443... Try connecting with SNI!")

while True:
    newsock, fromaddr = bind_socket.accept()
    conn = context.wrap_socket(newsock, server_side=True)
    print(f"Connection for: {conn.getpeercert()}")
    conn.close()
