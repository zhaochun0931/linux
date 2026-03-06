package com.example.my_spring_web_server;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {


// Get the current date and time
        LocalDateTime now = LocalDateTime.now();


// Define a friendly format
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formatDateTime = now.format(formatter);



        return "Hello, Spring Boot is up and running!" + formatDateTime;
    }
}
