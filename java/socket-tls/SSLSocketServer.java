import javax.net.ssl.*;
import java.io.*;
import java.security.KeyStore;

public class SSLSocketServer {
    public static void main(String[] args) throws Exception {
        // Set keystore
        System.setProperty("javax.net.ssl.keyStore", "keystore.jks");
        System.setProperty("javax.net.ssl.keyStorePassword", "changeit");

        SSLServerSocketFactory factory = (SSLServerSocketFactory) SSLServerSocketFactory.getDefault();
        SSLServerSocket serverSocket = (SSLServerSocket) factory.createServerSocket(8443);
        System.out.println("SSL Server started on port 8443");

        while (true) {
            try (SSLSocket socket = (SSLSocket) serverSocket.accept();
                 BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                 BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()))) {

                String line = reader.readLine();
                System.out.println("Received from client: " + line);

                writer.write("Hello from SSL server\n");
                writer.flush();
            }
        }
    }
}
