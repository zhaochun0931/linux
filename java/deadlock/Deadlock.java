public class Deadlock {
    private static final Object resource1 = new Object();
    private static final Object resource2 = new Object();

    public static void main(String[] args) {
        Thread thread1 = new Thread(() -> {
            synchronized (resource1) {
                System.out.println("Thread 1: Holding lock on resource 1...");
                try {
                    Thread.sleep(100); // Simulating some computation
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("Thread 1: Waiting for lock on resource 2...");
                synchronized (resource2) {
                    System.out.println("Thread 1: Holding lock on resource 1 and resource 2...");
                }
            }
        });

        Thread thread2 = new Thread(() -> {
            synchronized (resource2) {
                System.out.println("Thread 2: Holding lock on resource 2...");
                try {
                    Thread.sleep(100); // Simulating some computation
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("Thread 2: Waiting for lock on resource 1...");
                synchronized (resource1) {
                    System.out.println("Thread 2: Holding lock on resource 1 and resource 2...");
                }
            }
        });

        thread1.start();
        thread2.start();
    }
}
