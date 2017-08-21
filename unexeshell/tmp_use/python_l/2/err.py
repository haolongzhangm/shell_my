#!/usr/bin/env python

test_d = {'w':'123', 't':'fs'}

'''
1 / 0
'''

try:
    1 / 0
except ZeroDivisionError:
    print('ZeroDivisionError err')


def except_deep():
    print(test_d['e'])


try:
    except_deep()
except KeyError:
    print('KeyError;')
