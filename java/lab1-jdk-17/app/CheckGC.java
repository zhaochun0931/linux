import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;
import java.util.List;

public class CheckGC {
    public static void main(String[] args) {
        System.out.println("Java 版本: " + System.getProperty("java.version"));
        System.out.println("----------------------------------------");
        
        List<GarbageCollectorMXBean> gcBeans = ManagementFactory.getGarbageCollectorMXBeans();
        System.out.println("当前运行中生效的垃圾回收器：");
        for (GarbageCollectorMXBean gcBean : gcBeans) {
            System.out.println(" - " + gcBean.getName());
        }
        System.out.println("----------------------------------------");
    }
}
