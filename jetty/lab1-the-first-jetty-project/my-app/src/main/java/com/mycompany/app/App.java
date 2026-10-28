package com.mycompany.app;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.AbstractHandler;


import java.io.IOException;


/**
 * Hello world!
 */
public class App {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello World!");


        // 1. 创建 Server 实例，并绑定监听端口（例如 8080）
        Server server = new Server(8080);

        // 2. 设置请求处理器（Handler）
        server.setHandler(new AbstractHandler() {
            @Override
            public void handle(String target, Request baseRequest,
                               HttpServletRequest request, HttpServletResponse response)
                    throws IOException {
                // 设置响应类型与状态码
                response.setContentType("text/plain;charset=utf-8");
                response.setStatus(HttpServletResponse.SC_OK);

                // 输出响应内容
                response.getWriter().println("Hello, 嵌入式 Jetty 已启动！");

                // 标记请求已处理完毕，防止后续 Handler 继续捕获
                baseRequest.setHandled(true);
            }
        });

        // 3. 启动服务器
        server.start();

        // 4. 阻塞主线程，保持服务器持续运行
        server.join();

    }
}
