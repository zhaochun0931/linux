#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  // <-- Add this line for the sleep() function

int main() {
    // 1 Gigabyte of memory
    long long size = 1024LL * 1024LL * 1024LL;
    char *buffer;

    printf("Step 1: Program started. Find 'memory_demo' in htop.\n");
    printf("Press [Enter] to ask the OS for 1GB of memory...\n");
    getchar();

    // malloc() asks the OS for virtual address space.
    // It does NOT assign physical RAM yet.
    buffer = (char *)malloc(size);
    if (buffer == NULL) {
        printf("Memory allocation failed!\n");
        return 1;
    }

    printf("Step 2: malloc() finished!\n");
    printf("--> Look at htop: VIRT should have increased by ~1GB.\n");
    printf("--> Look at htop: RES is still tiny (almost 0).\n");
    printf("Press [Enter] to actually write data into this memory...\n");
    getchar();

    // Now we loop through that 1GB and write a number into it.
    // We step by 4096 bytes because that is the standard size of a "Memory Page" in Linux.
    // Touching each page forces the OS to finally back the virtual address with physical RAM.

    long long chunk_size = 100LL * 1024LL * 1024LL; // 100 Megabytes

    for (long long i = 0; i < size; i += 4096) {
        buffer[i] = 1;

        // Every time we finish filling a 100MB chunk, sleep for 10 seconds
        if ((i + 4096) % chunk_size == 0) {
            long long current_mb = (i + 4096) / (1024 * 1024);
            printf("--> Filled %lld MB of physical memory (RES). Sleeping 10 seconds...\n", current_mb);
            sleep(10);
        }
    }

    printf("Step 3: Writing finished!\n");
    printf("--> Look at htop: RES has now spiked to ~1GB to match VIRT!\n");
    printf("Press [Enter] to exit and free the memory...\n");
    getchar(); // Catch the newline from the previous input
    getchar(); // Wait for actual user Enter press

    free(buffer);
    return 0;
}
