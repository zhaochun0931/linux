import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.KeyStore;

public class SimpleHttpsClient {
    public static void main(String[] args) throws Exception {
        String truststorePath = "test-keystore.p12";
        char[] password = "password123".toCharArray();

        // 1. 加载包含 CA 根证书的 Truststore
        KeyStore ts = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream(truststorePath)) {
            ts.load(fis, password);
        }

        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(ts);

        // 2. 初始化客户端 SSLContext
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, tmf.getTrustManagers(), null);

        // 3. 发送请求
        // 注意：若原证书没有添加 SAN 扩展（IP/localhost），默认域名校验可能会阻断。
        // 如果报错 "No subject alternative names present"，可参考下一步。
        HttpClient client = HttpClient.newBuilder()
                .sslContext(sslContext)
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://localhost:8443/test"))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("HTTP Status: " + response.statusCode());
        System.out.println("Response Body: " + response.body());
    }
}
