import java.io.*;
import java.net.*;

public class PersistentSocketClient {
    public static void main(String[] args) throws IOException, InterruptedException {
        Socket socket = new Socket("localhost", 12345);
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

        for (int i = 0; i < 5; i++) {
            out.println("Message " + i);
            Thread.sleep(1000);  // simulate delay between messages
        }

        socket.close();
    }
}
