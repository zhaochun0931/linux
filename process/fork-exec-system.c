#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    printf("Parent PID: %d\n", getpid());

    // --- fork() example ---
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork failed");
        exit(1);
    } else if (pid == 0) {
        // Child process
        printf("Child (fork) PID: %d, parent PID: %d\n", getpid(), getppid());

        // --- exec() example ---
        char *args[] = {"ls", "-l", NULL};
        printf("Child will exec 'ls -l'\n");
        execvp("ls", args);

        perror("exec failed");
        exit(1);
    } else {
        // Parent process
        wait(NULL);
        printf("Parent after child (fork+exec) finished\n");

        // --- system() example ---
        printf("Parent will run 'echo Hello via system'\n");
        int ret = system("echo Hello via system");
        printf("system() returned: %d\n", ret);
    }

    return 0;
}
