import javax.net.ssl.*;
import java.io.*;

public class TestClient {
    public static void main(String[] args) throws Exception {
        System.setProperty("javax.net.ssl.trustStore", "truststore.jks");
        System.setProperty("javax.net.ssl.trustStorePassword", "changeit");

        SSLContext ctx = SSLContext.getInstance("TLS");
        ctx.init(null, null, null);

        SSLSocketFactory factory = ctx.getSocketFactory();
        SSLSocket socket = (SSLSocket) factory.createSocket("localhost", 8443);
        socket.startHandshake();

        System.out.println("TLS handshake successful!");
        socket.close();
    }
}
