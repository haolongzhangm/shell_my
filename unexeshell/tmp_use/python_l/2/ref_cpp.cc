#include <iostream>
#include <stdio.h>

using namespace std;

class Foo
{
	private:
		//int value;
		int value = 300;
		void set_value(int);
		static void _value(int);
	
	public:
		int get_value();
		int value_p = 20;
		void update_value(int);
		static int tmo();
		static void p_value();
};

void Foo::set_value(int a)
{
	this->value = a;
	this->value_p = a;
}

void Foo::update_value(int a)
{
	this->set_value(a);
}

int Foo::get_value()
{
	return this->value;
}

void Foo::p_value()
{
	cout << "come from static fuc\n";
}

int main()
{

	//cout << &Foo::value_p << "\n";
	//Foo::update_value(10);
	//Foo::_value(100);
	//Foo::p_value();

	Foo *foo = new Foo;
	Foo *foo_s = new Foo;
	//cout << foo->get_value() << "\n";

	cout <<  foo->p_value << "\n" <<  foo_s->p_value << "\n";
	printf("foo->p_value = %p, foo_s->p_value = %p\n", foo->p_value, foo_s->p_value);

	//foo->update_value(9);
	//cout << foo->get_value() << "\n";
}
