package com.mycompany.app;


import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;
import java.util.concurrent.CountDownLatch;

/**
 * Hello world!
 */
public class App {


    private static final String BOOTSTRAP_SERVERS = "localhost:9092";
    private static final String TOPIC = "test-topic";
    private static final int TOTAL_MESSAGES = 1_000_000;


    
    public static void main(String[] args) {
        System.out.println("Hello World!");

        // 1. Configure the Producer
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        // Performance tuning for high throughput
        props.put(ProducerConfig.BATCH_SIZE_CONFIG, Integer.toString(64 * 1024)); // 64 KB batch size
        props.put(ProducerConfig.LINGER_MS_CONFIG, "20"); // Wait up to 20ms to fill the batch
        props.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy"); // Compress messages to save bandwidth
        props.put(ProducerConfig.ACKS_CONFIG, "1"); // "1" or "all" depending on your durability needs

        // 2. Initialize the Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);

        // Use a Latch to wait for all async callbacks to finish before exiting
        CountDownLatch latch = new CountDownLatch(TOTAL_MESSAGES);

        System.out.println("Starting to send " + TOTAL_MESSAGES + " messages...");
        long startTime = System.currentTimeMillis();

        // 3. Send Messages Loop
        for (int i = 0; i < TOTAL_MESSAGES; i++) {
            String key = "key-" + i;
            String value = "message-payload-data-number-" + i;

            ProducerRecord<String, String> record = new ProducerRecord<>(TOPIC, key, value);

            // Send asynchronously with a callback
            producer.send(record, new Callback() {
                @Override
                public void onCompletion(RecordMetadata metadata, Exception exception) {
                    latch.countDown();
                    if (exception != null) {
                        System.err.println("Error sending message: " + exception.getMessage());
                    }
                }
            });

            // Optional: Print progress every 100k messages so you know it's working
            if (i % 100_000 == 0 && i > 0) {
                System.out.println("Sent " + i + " messages to the local buffer...");
            }
        }

        // 4. Wait for all messages to be acknowledged by Kafka
        try {
            System.out.println("All messages buffered. Waiting for Kafka ACKs...");
            latch.await();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("Execution interrupted.");
        } finally {
            // Always close the producer to flush remaining records and release resources
            producer.close();
        }

        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        System.out.println("==========================================");
        System.out.println("Finished sending 1,000,000 messages!");
        System.out.println("Total Time: " + duration + " ms (" + (duration / 1000.0) + " seconds)");
        System.out.println("Throughput: " + (TOTAL_MESSAGES / (duration / 1000.0)) + " msgs/sec");
        System.out.println("==========================================");
        
    }
}
