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
        int status;
        waitpid(pid, &status, 0);  // wait for fork+exec child
        printf("Parent after fork+exec child finished\n");

        // --- system() example ---
        printf("Parent will run 'echo Hello via system'\n");

        pid_t system_pid = fork();
        if (system_pid == 0) {
            // This is the child that system() would create
            printf("system() child PID: %d, parent PID: %d\n", getpid(), getppid());
            execl("/bin/sh", "sh", "-c", "echo Hello via system", (char *)NULL);
            perror("execl failed");
            exit(1);
        } else if (system_pid > 0) {
            waitpid(system_pid, &status, 0);
            printf("system() child finished, parent PID: %d\n", getpid());
        } else {
            perror("fork for system() failed");
        }
    }

    return 0;
}
