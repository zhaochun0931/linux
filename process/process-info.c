#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <limits.h>   // for PATH_MAX
#include <errno.h>

void show_pid_info() {
    pid_t pid = getpid();
    pid_t ppid = getppid();
    printf("Process ID (PID): %d\n", pid);
    printf("Parent Process ID (PPID): %d\n", ppid);
}

void show_status() {
    printf("\n=== /proc/self/status (basic info) ===\n");
    FILE *fp = fopen("/proc/self/status", "r");
    if (!fp) { perror("fopen status"); return; }
    char line[256];
    int count = 0;
    while (fgets(line, sizeof(line), fp) && count < 15) {
        printf("%s", line);
        count++;
    }
    fclose(fp);
}

void show_maps() {
    printf("\n=== /proc/self/maps (memory map, first 10 lines) ===\n");
    FILE *fp = fopen("/proc/self/maps", "r");
    if (!fp) { perror("fopen maps"); return; }
    char line[256];
    int count = 0;
    while (fgets(line, sizeof(line), fp) && count < 10) {
        printf("%s", line);
        count++;
    }
    fclose(fp);
}

void show_fds() {
    printf("\n=== /proc/self/fd (open file descriptors) ===\n");
    DIR *dir = opendir("/proc/self/fd");
    if (!dir) { perror("opendir fd"); return; }

    struct dirent *entry;
    char path[PATH_MAX];
    char link[PATH_MAX];
    ssize_t len;

    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_name[0] == '.') continue;

        int n = snprintf(path, sizeof(path), "/proc/self/fd/%s", entry->d_name);
        if (n < 0 || n >= (int)sizeof(path)) {
            fprintf(stderr, "Path truncated for fd %s\n", entry->d_name);
            continue;
        }

        len = readlink(path, link, sizeof(link)-1);
        if (len != -1) {
            link[len] = '\0';
            printf("FD %s -> %s\n", entry->d_name, link);
        } else {
            printf("FD %s -> (unreadable: %s)\n", entry->d_name, strerror(errno));
        }
    }
    closedir(dir);
}

void show_sched() {
    printf("\n=== /proc/self/sched (scheduling info, first 10 lines) ===\n");
    FILE *fp = fopen("/proc/self/sched", "r");
    if (!fp) { perror("fopen sched"); return; }
    char line[256];
    int count = 0;
    while (fgets(line, sizeof(line), fp) && count < 10) {
        printf("%s", line);
        count++;
    }
    fclose(fp);
}

int main() {
    printf("🔍 Linux Process Inspector\n");
    show_pid_info();
    show_status();
    show_maps();
    show_fds();
    show_sched();
    return 0;
}
