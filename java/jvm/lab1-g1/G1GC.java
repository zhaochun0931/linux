import java.util.*;

/**
 * Lab to demonstrate G1 GC behaviors.
 */
public class G1GC {
    // A cache to hold objects in the "Old Generation"
    private static final List<byte[]> cache = new LinkedList<>();

    public static void main(String[] args) throws InterruptedException {
        System.out.println("--- G1 GC Lab Started ---");
        
        // 1. Fill the "Old Gen" slowly to trigger Concurrent Marking
        for (int i = 0; i < 50; i++) {
            // Add 2MB to the cache
            cache.add(new byte[2 * 1024 * 1024]);
            System.out.println("Cache size: " + (cache.size() * 2) + " MB");

            // 2. Create "Noise" (Young Gen objects that die quickly)
            // This triggers Young GCs
            for (int j = 0; j < 100; j++) {
                byte[] noise = new byte[512 * 1024]; // 0.5 MB
            }
            
            Thread.sleep(100); // Slow down so we can see it in logs
        }

        System.out.println("--- Lab Finished ---");
    }
}
