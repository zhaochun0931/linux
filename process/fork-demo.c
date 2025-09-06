#include <stdio.h>
#include <unistd.h>

int main() {
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork failed");
    } else if (pid == 0) {
        printf("I am the child, PID=%d\n", getpid());
        printf("Press Enter to continue...\n");
        getchar();  // pause child
    } else {
        printf("I am the parent, PID=%d, child PID=%d\n", getpid(), pid);
        printf("Press Enter to continue...\n");
        getchar();  // pause parent
    }
    return 0;
}
