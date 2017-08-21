#!/usr/bin/env python
# coding: utf-8
import sys

class field_foo(object):

    #静态字段
    foo_describe = 'describe for field'

    def __init__(self, name):
        #普通字段
        self.name = name


test_field = field_foo('haha')

print('class geniric field name  = %s' % test_field.name)

print('class static filed foo_describe via class = %s' % test_field.foo_describe)

print('class static filed foo_describe via object = %s' % field_foo.foo_describe)
