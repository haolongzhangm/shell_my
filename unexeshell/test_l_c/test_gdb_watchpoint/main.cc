#include <iostream>

using namespace std;
class Base
{
  public:
    Base(){}
    virtual ~Base(){}
    virtual void print(){ cout << "base" << endl; }
};
class sub :public Base
{
  public:
    sub(){}
    ~sub(){}
    void print(){ cout << "sub" << endl; }
};

int main() {
  sub d;
  Base * pb1 = dynamic_cast<Base*>(&d);
  Base * pb2 = static_cast<Base*>(&d);
  pb1->print();
  pb2->print();
}
