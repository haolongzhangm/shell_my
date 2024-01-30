//! test default destructor order


#include <cstdio>
#include <memory>
#include <unordered_map>

class A {
public:
  ~A() {printf("A::~A()\n");}
};

class B {
public:
  ~B() {printf("B::~B()\n");}
};

class TEST {
public:
    ~TEST() {printf("TEST::~TEST()\n");}
    void add_a (int i) {m[i] = std::make_shared<A>();}
    void add_b (int i) {n[i] = std::make_shared<B>();}

private:
  std::unordered_map<int, std::shared_ptr<A>> m;
  std::unordered_map<int, std::shared_ptr<B>> n;
};

class TEST_B {
public:
    ~TEST_B() {printf("TEST_B::~TEST_B()\n");}
    void add_b (int i) {n[i] = std::make_shared<B>();}
    void add_a (int i) {m[i] = std::make_shared<A>();}

private:
  std::unordered_map<int, std::shared_ptr<A>> m;
  std::unordered_map<int, std::shared_ptr<B>> n;
};

class TEST_C {
public:
    ~TEST_C() {printf("TEST_C::~TEST_C()\n");
        m.clear();
        n.clear();
    }
    void add_b (int i) {n[i] = std::make_shared<B>();}
    void add_a (int i) {m[i] = std::make_shared<A>();}

private:
  std::unordered_map<int, std::shared_ptr<A>> m;
  std::unordered_map<int, std::shared_ptr<B>> n;
};

class TEST_D {
public:
    ~TEST_D() {printf("TEST_D::~TEST_D()\n");
        m.clear();
    }
    void add_b (int i) {n[i] = std::make_shared<B>();}
    void add_a (int i) {m[i] = std::make_shared<A>();}

private:
  std::unordered_map<int, std::shared_ptr<A>> m;
  std::unordered_map<int, std::shared_ptr<B>> n;
};

int main() {
    TEST t;
    t.add_a(1);
    t.add_b(2);

    TEST_B t_b;
    t_b.add_a(1);
    t_b.add_b(2);

    TEST_C t_c;
    t_c.add_a(1);
    t_c.add_b(2);

    TEST_D t_d;
    t_d.add_a(1);
    t_d.add_b(2);
}
