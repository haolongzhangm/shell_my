#!/usr/bin/env python

import time

#'''
#step one
@measure_time
def foo():
    print('foo')
    a = 0
    for i in range(1, 1000):
        a = a + i
    print(a)


def foo_2():
    print('foo_2')
#'''  


'''
#step two
def foo():
    start_time = time.time()
    print('foo')
    a = 0
    for i in range(1, 1000):
        a = a + i
    print(a)

    end_time = time.time()
    print('foo use time %f ms' % ((end_time - start_time) * 10))


def foo_2():
    start_time = time.time()
    print('foo_2')
    end_time = time.time()
    print('foo_2 use time %f ms' % ((end_time - start_time) * 10))


'''


#'''
#step three
def measure_time(func):
    def wrapper():
        start_time = time.time()
        func()
        end_time = time.time()
        print('%s use time %f ms' % (func.__name__, (end_time - start_time) * 10))

    return wrapper
'''
foo = measure_time(foo)
foo_2 = measure_time(foo_2)
'''


#step four


foo()
foo_2()
