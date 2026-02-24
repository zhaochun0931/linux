package com.mycompany.app;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class App {
    // Create a logger instance for this class
    private static final Logger logger = LogManager.getLogger(App.class);

    public static void main(String[] args) {
        logger.info("Application has started.");

        try {
            int result = 10 / 0;
        } catch (Exception e) {
            // Log errors with stack traces
            logger.error("Something went wrong!", e);
        }

        logger.debug("Finishing the main method.");
    }
}
