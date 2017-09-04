#!/usr/bin/env python

class func_foo(object):


    def __init__(self, name):
        self.name = name
        print('name = %s' % self.name)
        self.static_func()

    def general_func(self):
        print('this is a general_func')

    @classmethod
    def class_func(cls):
        print('this is a class func')

    @staticmethod
    def static_func():
        print('this is a static func')


object_func_foo = func_foo('func_foo example')

object_func_foo.general_func()

func_foo.class_func()

func_foo.static_func()

#test
#object_func_foo.class_func()
#object_func_foo.static_func()

#test more
#func_foo.general_func()
