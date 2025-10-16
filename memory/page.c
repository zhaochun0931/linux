#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

// Get physical address from virtual address via /proc/self/pagemap
uint64_t virt_to_phys(void *virt_addr) {
    uint64_t virt_pfn;
    uint64_t offset = (uint64_t)virt_addr / getpagesize() * sizeof(uint64_t);
    uint64_t phys_pfn;
    int pagemap = open("/proc/self/pagemap", O_RDONLY);

    if (pagemap < 0) {
        perror("open pagemap");
        return 0;
    }

    if (lseek(pagemap, offset, SEEK_SET) == (off_t)-1) {
        perror("lseek");
        close(pagemap);
        return 0;
    }

    if (read(pagemap, &virt_pfn, sizeof(virt_pfn)) != sizeof(virt_pfn)) {
        perror("read");
        close(pagemap);
        return 0;
    }

    close(pagemap);

    // Check if page is present
    if (!(virt_pfn & (1ULL << 63))) {
        printf("Page not present in memory!\n");
        return 0;
    }

    phys_pfn = virt_pfn & ((1ULL << 55) - 1);
    return (phys_pfn * getpagesize()) + ((uint64_t)virt_addr % getpagesize());
}

int main() {
    const int PAGES = 3;
    size_t page_size = getpagesize();

    printf("Page size: %zu bytes\n\n", page_size);

    // Allocate 3 pages
    char *buf = aligned_alloc(page_size, PAGES * page_size);
    if (!buf) {
        perror("alloc");
        return 1;
    }

    // Touch each page to ensure it’s mapped
    for (int i = 0; i < PAGES; i++) {
        buf[i * page_size] = i;
    }

    printf("Virtual and Physical Address Mapping:\n");
    printf("------------------------------------\n");

    for (int i = 0; i < PAGES; i++) {
        void *virt_addr = &buf[i * page_size];
        uint64_t phys_addr = virt_to_phys(virt_addr);
        printf("Page %d:\n", i);
        printf("  Virtual: %p\n", virt_addr);
        printf("  Physical: 0x%llx\n", (unsigned long long)phys_addr);
    }

    free(buf);
    return 0;
}
