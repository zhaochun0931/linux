package com.example.demo_fatjar;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DemoFatjarApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoFatjarApplication.class, args);
	}

    @GetMapping("/")
        public String hello() {
            return "Hello from Spring Initializr curl project!";
        }

}
