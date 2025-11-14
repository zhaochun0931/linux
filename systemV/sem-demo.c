#include <stdio.h>
#include <sys/ipc.h>
#include <sys/sem.h>

int main() {
    key_t key = ftok("semfile", 65);

    // Create semaphore
    int semid = semget(key, 1, 0666 | IPC_CREAT);

    // Initialize to 1
    semctl(semid, 0, SETVAL, 1);

    printf("Semaphore created with value 1\n");

    // Perform wait (decrement)
    struct sembuf sb = {0, -1, 0};
    semop(semid, &sb, 1);
    printf("Semaphore decremented (locked)\n");

    // Perform signal (increment)
    sb.sem_op = 1;
    semop(semid, &sb, 1);
    printf("Semaphore incremented (unlocked)\n");

    // Remove semaphore
    semctl(semid, 0, IPC_RMID);
    return 0;
}
