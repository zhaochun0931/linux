package com.mycompany.app;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class App {
    private static final Logger logger = LogManager.getLogger(App.class);

    public static void main(String[] args) {
        logger.info("Application 'LogMaster' version 1.0 is initializing.");

        // TRACE: High-volume, granular details (e.g., method entry/exit)
        logger.trace("Entering main method with arguments: {}", (Object) args);

        try {
            int numerator = 10;
            int denominator = 0;

            // DEBUG: Useful for developers during troubleshooting
            logger.debug("Attempting division: {} divided by {}", numerator, denominator);

            if (denominator == 0) {
                // WARN: Potentially harmful situations or unexpected paths
                logger.warn("Calculation warning: Division by zero is imminent!");
            }

            int result = numerator / denominator;
            logger.info("Calculation successful. Result: {}", result);

        } catch (ArithmeticException e) {
            // ERROR: Severe issues that might allow the app to continue
            logger.error("Calculation failed! A mathematical error occurred: {}", e.getMessage());
            
            // Logging the full stack trace is usually best for errors
            logger.error("Stack trace details:", e);
        } catch (Exception e) {
            logger.fatal("Critical system failure encountered!", e);
        }

        logger.info("Application processing complete.");
        logger.debug("Exiting main method. Cleanup successful.");
    }
}
