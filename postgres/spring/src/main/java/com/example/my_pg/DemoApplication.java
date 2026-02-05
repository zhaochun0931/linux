package com.example.my_pg;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;



@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}



@Bean
    CommandLineRunner initDatabase(UserRepository repository) {
        return args -> {
            // This is your "Insert one entry" logic
            User newUser = new User("xiaoming", "xiaoming@example.com");
            repository.save(newUser);
            
            System.out.println(">>> Database entry inserted: " + newUser.getName());
        };
    }

}
