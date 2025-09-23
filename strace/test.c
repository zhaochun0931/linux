#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *f = fopen("/tmp/config.yaml", "r");
    if (f == NULL) {
        perror("Error opening file");
        return 1;
    }
    printf("File opened successfully!\n");
    fclose(f);
    return 0;
}
