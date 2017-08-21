#!/usr/bin/env python

class property_wayb_foo(object):

    def __init__(self, value):
        self.age_n = value

    def get_age(self):
        print('get age_n = %d' % self.age_n)
        return self.age_n

    def set_age(self, value):
        self.age_n = value

    age = property(get_age, set_age)

object_property_wayb_foo = property_wayb_foo(2)

object_property_wayb_foo.age

object_property_wayb_foo.age= 18

object_property_wayb_foo.age
