package com.example.demo.batch;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class BatchService {

    @Autowired
    private BatchRepository repository;

    @PersistenceContext
    private EntityManager entityManager;

    private final AtomicInteger progress = new AtomicInteger(0);

    @Async
    @Transactional
    public void generateMillionRows() {
        int total = 1_000_000;
        int batchSize = 1000;
        List<BatchData> list = new ArrayList<>();

        for (int i = 1; i <= total; i++) {
            list.add(new BatchData("Record " + i));

            if (i % batchSize == 0) {
                repository.saveAll(list);
                list.clear();
                entityManager.flush();
                entityManager.clear(); // Important to keep memory low
                progress.set(i);
            }
        }
    }

    public int getProgress() { return progress.get(); }
}