package com.example.demo.batch; // Must start with your main package name

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/batch")
public class BatchController {

    @Autowired
    private BatchService batchService;

    @PostMapping("/run")
    public String run() {
        batchService.generateMillionRows();
        return "Started inserting 1,000,000 records...";
    }

    @GetMapping("/status")
    public String status() {
        return "Progress: " + batchService.getProgress() + " / 1,000,000";
    }
}