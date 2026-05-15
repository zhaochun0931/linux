package com.example.demo.batch;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class BatchData {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "batch_seq")
    @SequenceGenerator(name = "batch_seq", allocationSize = 1000)
    private Long id;

    private String payload;
    private LocalDateTime timestamp;

    public BatchData() {}
    public BatchData(String payload) {
        this.payload = payload;
        this.timestamp = LocalDateTime.now();
    }
    // Getters/Setters...
}
