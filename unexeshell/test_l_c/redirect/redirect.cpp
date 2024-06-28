#include <fcntl.h>
#include <unistd.h>

#include <cstdarg>
#include <cstdio>

namespace {
FILE *redirect_file_fd = nullptr;
}
__attribute__((constructor)) void redirect_printf_init() {
    redirect_file_fd = fopen("redirect.txt", "w");
    if (redirect_file_fd == nullptr) {
        __builtin_trap();
    }
}

__attribute__((destructor)) void redirect_printf_uninit() {
    if (redirect_file_fd != nullptr) {
        fclose(redirect_file_fd);
    }
}

extern "C" {
int printf(const char *format, ...) {
    //! write to redirect_file_fd
    va_list args;
    va_start(args, format);
    int ret = vfprintf(redirect_file_fd, format, args);
    va_end(args);

    fflush(redirect_file_fd);

    return ret;
}

//! why need implementation puts? when build with fast, or O1, O2 or O3, if
//! printf not use fmt, it will be optimized as puts for example: printf("hello
//! world\n") will be optimized as puts("hello world")
int puts(const char *s) {
    int ret = fprintf(redirect_file_fd, "%s\n", s);
    fflush(redirect_file_fd);
    return ret;
}
}

int main() {
    printf("hello world");
    printf("hello world\n");
    printf("kkkkk:%s\n", "kkkkk");
    return 0;
}
