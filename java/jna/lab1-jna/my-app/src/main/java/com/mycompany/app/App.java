package com.mycompany.app;


import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;

/**
 * Hello world!
 */
public class App {

    /**
     * 1. Define an interface that extends com.sun.jna.Library.
     * This interface acts as the bridge to the native C library.
     */
    public interface CStdLib extends Library {

        // 2. Load the native library.
        // Platform.C_LIBRARY_NAME automatically resolves to "msvcrt" on Windows, "c" on Linux/Mac.
        CStdLib INSTANCE = (CStdLib) Native.load(Platform.C_LIBRARY_NAME, CStdLib.class);

        // 3. Declare the native functions exactly as they appear in C.
        // C signature: int printf(const char *format, ...);
        void printf(String format, Object... args);

        // C signature: double cos(double x);
        double cos(double x);
    }

    
    public static void main(String[] args) {
        System.out.println("Hello World!");

        System.out.println("--- Starting JNA Demonstration ---");

        try {
            // Call the native C printf function
            CStdLib.INSTANCE.printf("Hello from native C! You are running on OS: %s\n", Platform.RESOURCE_PREFIX);

            // Call the native C cos (cosine) function
            double radians = 1.0;
            double result = CStdLib.INSTANCE.cos(radians);

            // Print the result using standard Java
            System.out.println("Hello from Java! The native C library calculated the cosine of " + radians + " as: " + result);

        } catch (UnsatisfiedLinkError e) {
            System.err.println("Failed to load native library or function. Check your JNA setup and temp directory permissions.");
            e.printStackTrace();
        }

        System.out.println("--- End of Demonstration ---");
    }
    
}
