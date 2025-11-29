import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args) throws Exception {
        ServerSocket server = new ServerSocket(8080);
        System.out.println("FD Demo Server started on 8080...");

        // Background thread to print FD count
        new Thread(() -> {
            while (true) {
                try {
                    Process p = Runtime.getRuntime().exec("ls /proc/self/fd | wc -l");
                    p.waitFor();
                    byte[] output = p.getInputStream().readAllBytes();
                    System.out.println("FD count = " + new String(output).trim());
                    Thread.sleep(1000);
                } catch (Exception e) {}
            }
        }).start();

        // Accept connections forever
        while (true) {
            Socket s = server.accept();
            System.out.println("Client connected: " + s);
        }
    }
}

