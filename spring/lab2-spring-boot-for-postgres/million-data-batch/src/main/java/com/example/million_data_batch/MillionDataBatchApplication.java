package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync; // <--- ADD THIS LINE


@SpringBootApplication
@EnableAsync // <--- DON'T FORGET THIS

public class MillionDataBatchApplication {

	public static void main(String[] args) {
		SpringApplication.run(MillionDataBatchApplication.class, args);
	}

}
