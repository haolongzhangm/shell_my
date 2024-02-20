//! test flush before abort

#include <algorithm>
#include <iostream>
#include <iterator>
#include <ostream>

void do_nothing() {
    printf("run do_nothing\n");
}

void flush() {
    printf("run flush\n");
    fflush(stdout);
    fflush(stderr);
}

void cpp_std_end() {
    std::cout << "run std::endl" << std::endl;
    std::cout << std::endl;
}
int main() {
    printf("we will crash now!\n");
    //! get env to decide use flush or endl or do nothing
    char* env = getenv("FLUSH");
    if (env) {
        std::string flush_str(env);
        std::transform(flush_str.begin(), flush_str.end(), flush_str.begin(), ::tolower);
        if (flush_str == "flush") {
            flush();
        } else if (flush_str == "endl") {
            cpp_std_end();
        } else if (flush_str == "nothing") {
            do_nothing();
        }
    }

    abort();
}
