import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args) throws Exception {
        ServerSocket server = new ServerSocket(8080);
        System.out.println("Listening on port 8080...");

        while (true) {
            Socket s = server.accept();
            System.out.println("Client connected: " + s);
        }
    }
}

