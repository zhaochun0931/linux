import javax.net.ssl.*;
import java.io.*;

public class SSLSocketClient {
    public static void main(String[] args) throws Exception {
        // Set truststore
        System.setProperty("javax.net.ssl.trustStore", "truststore.jks");
        System.setProperty("javax.net.ssl.trustStorePassword", "changeit");

        SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();
        try (SSLSocket socket = (SSLSocket) factory.createSocket("localhost", 8443);
             BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
             BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()))) {

            writer.write("Hello from client\n");
            writer.flush();

            String response = reader.readLine();
            System.out.println("Server replied: " + response);
        }
    }
}
