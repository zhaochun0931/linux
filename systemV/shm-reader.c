#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>

int main() {
    key_t key = ftok("shmfile", 65);

    int shmid = shmget(key, 1024, 0666);

    char *str = (char*) shmat(shmid, NULL, 0);

    printf("Data read from shared memory: %s\n", str);

    // Detach and destroy
    shmdt(str);
    shmctl(shmid, IPC_RMID, NULL);

    return 0;
}
