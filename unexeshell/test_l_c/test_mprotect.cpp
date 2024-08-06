#include <sys/mman.h>

#include <cerrno>
#include <cstdint>
#include <cstdio>
#include <vector>

namespace {
#define ASSERT(expr)                          \
    if (!(expr)) {                            \
        printf("assert failed: %s\n", #expr); \
        __builtin_trap();                     \
    }

}  // namespace

int main() {
    int8_t array[10] = {0, 1, 2, 3, 4, 5};

    std::vector<int8_t> vec(array, array + sizeof(array) / sizeof(array[0]));

    auto show_vec = [&vec]() {
        for (auto i : vec) {
            printf("%d\n", i);
        }
    };

    auto alignment = 4096;
    auto get_aligned = [alignment](size_t v) {
        auto mod = v & (alignment - 1);
        return v + ((alignment - mod) & (alignment - 1));
    };

    show_vec();
    vec[9] = 9;

    show_vec();

    //! resize vec to page size as mprotect requires the size to be multiple of
    //! page size
    auto new_vec_size = get_aligned(vec.size());
    vec.resize(new_vec_size);

    //! get the page aligned address
    auto page_aligned_address = (int8_t*)get_aligned((uintptr_t)&vec[0]);
    auto offset = (uintptr_t)(page_aligned_address - (uintptr_t)&vec[0]);
    auto p_len = vec.size() - offset;
    printf("try mprotect at: %p(%p) with size: %lu offset: %zu\n",
           page_aligned_address, vec.data(), p_len, offset);

    //! now we will use mprotect to protect the memory of vec
    auto ret = mprotect(page_aligned_address, p_len, PROT_READ);

    if (ret != 0) {
        printf("mprotect failed, errno = %d\n", errno);
        __builtin_trap();
    }

    printf("mprotect success\n");

    printf("test write to triger segmentation fault\n");
    vec[8] = 8;
    vec[offset] = 0; // this will cause a segmentation fault

    return 0;
}
