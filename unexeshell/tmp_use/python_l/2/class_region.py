#!/usr/bin/env python

class func_foo(object):

    public_name = 'public name'
    __private_name = 'priavte name'


    def __init__(self, name):
        self.name = name
        print('name = %s' % self.name)

    def general_func(self):
        print('this is a general_func')

    def __general_func(self):
        print('private func')

    @classmethod
    def class_func(cls):
        print('this is a class func')

    @staticmethod
    def static_func():
        print('this is a static func')


object_func_foo = func_foo('func_foo example')

object_func_foo.general_func()

print(object_func_foo.public_name)

#print(object_func_foo.__private_name)

#print(object_func_foo._func_foo__private_name)

#object_func_foo.__general_func()

#object_func_foo._func_foo__general_func()
