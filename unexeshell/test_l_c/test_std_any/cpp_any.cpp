#include <any>
#include <iostream>
#include <string>
#include <vector>

class MyClass {
   public:
    //! construction
    MyClass() {
        //! show some message
        std::cout << "MyClass::MyClass()" << std::endl;
    }
};

int main() {
    //! define a vector of any type
    std::vector<std::any> any_vec;
    //! push back an integer
    any_vec.push_back(1);
    //! push back a string
    any_vec.push_back(std::string("Hello"));
    //! push back a double
    any_vec.push_back(3.14);
    //! push back a char
    any_vec.push_back('a');
    //! push back a class
    any_vec.push_back(MyClass());

    for (auto &&i : any_vec) {
        //! print the type of the element
        std::cout << i.type().name() << std::endl;
        //! print the value of the element if is a int
        if (i.type() == typeid(int)) {
            std::cout << std::any_cast<int>(i) << std::endl;
        }
    }
}
