#!/usr/bin/env python

class property_waya_foo(object):

    def __init__(self, value):
        self.age_n = value

    @property
    def age(self):
        print('get age_n = %d' % self.age_n)
        return self.age_n

    @age.setter
    def age(self, value):
        self.age_n = value

object_property_waya_foo = property_waya_foo(0)

object_property_waya_foo.age

object_property_waya_foo.age= 18

object_property_waya_foo.age
