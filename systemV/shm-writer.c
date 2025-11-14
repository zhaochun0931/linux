#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string.h>

int main() {
    // Generate a key
    key_t key = ftok("shmfile", 65);

    // Create shared memory segment
    int shmid = shmget(key, 1024, 0666|IPC_CREAT);

    // Attach to shared memory
    char *str = (char*) shmat(shmid, NULL, 0);

    // Write to shared memory
    strcpy(str, "Hello from Writer (System V IPC)");

    printf("Data written to shared memory: %s\n", str);

    return 0;
}
