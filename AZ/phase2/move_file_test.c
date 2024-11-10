#include "types.h"
#include "user.h"
//#include "syscall.h"
#include "stat.h"



int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf(2, "Usage: movetest src_file dest_dir\n");
        exit();
    }

    if (move_file(argv[1], argv[2]) == 0) {
        printf(1, "File moved successfully.\n");
    } else {
        printf(2, "Error moving file.\n");
    }
    exit();
}
