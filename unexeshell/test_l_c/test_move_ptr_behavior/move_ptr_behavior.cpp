#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <memory>

//! define foo class
class foo {
public:
    foo() {
        printf("foo::foo()\n");
        a = 9;
    }
    ~foo() {
        printf("foo::~foo()\n");
    }

    int a;
};

int main() {

    foo f;
    printf("f.a = %d a: %p\n", f.a, &f.a);

    foo h = std::move(f);

    printf("f.a = %d a: %p\n", f.a, &f.a);
    printf("h.a = %d a: %p\n", h.a, &h.a);

    std::shared_ptr<int> m_int;

    m_int = std::make_shared<int>(10);
    printf("m_int: %p\n", m_int.get());

    std::shared_ptr<int> m_int2 = std::move(m_int);
    printf("m_int: %p\n", m_int.get());
    printf("m_int2: %p\n", m_int2.get());

    m_int = nullptr;
    printf("m_int2: %p\n", m_int2.get());
}
