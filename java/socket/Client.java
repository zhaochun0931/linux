import java.io.*;
import java.net.*;

public class Client {

    public static void main(String[] args) {
        try {
            Socket socket = new Socket("localhost", 5000);

            // Input stream from server
            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            // Output stream to server
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

            // Input stream from user
            BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));

            String message;
            while (true) {
                System.out.print("Enter message to send to server: ");
                message = userInput.readLine();
                out.println(message);

                String serverResponse = in.readLine();
                System.out.println("Server response: " + serverResponse);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
