#include <iostream>
#include <vector>

template <typename T>
struct MyAllocator {
    using value_type = T;

    MyAllocator(T* external_array, size_t size) : external_array(external_array),m_size(size) {}

    T* allocate(std::size_t n) {
        printf("into allocate\n");
        if (n == m_size) {  // Ensure the allocation size matches the array size
            return external_array;
        } else {
            throw std::bad_alloc();  // Disallow allocation of different size
        }
    }

    void deallocate(T* p, std::size_t) noexcept {
    }
    T * external_array;
    size_t m_size;
};

int main() {
    int8_t a[10] = {0};

    for (int i = 0; i < 10; i++) {
        a[i] = i;
    }

    printf("a ptr: %p\n", a);

    for (int i = 0; i < 10; i++) {
        a[i] = i;
    }
    MyAllocator<int8_t> allocator(a, 10);
    std::vector<int8_t, MyAllocator<int8_t>> vec(allocator);
    vec.resize(10);

    // Print the address of the vector's underlying array
    printf("v ptr: %p\n", vec.data());
    for (int i = 0; i < 10; i++) {
        printf("%d ", vec[i]);
    }

    return 0;
}

