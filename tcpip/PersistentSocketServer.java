import java.net.*;
import java.io.*;

public class PersistentSocketServer {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(12345);
        System.out.println("Server started, waiting for connection...");
        Socket clientSocket = serverSocket.accept();
        System.out.println("Client connected!");

        BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
        String line;
        while ((line = in.readLine()) != null) {
            System.out.println("Received: " + line);
        }

        in.close();
        clientSocket.close();
        serverSocket.close();
    }
}
