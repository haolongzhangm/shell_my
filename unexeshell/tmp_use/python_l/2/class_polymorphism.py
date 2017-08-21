#!/usr/bin/env python

class animal(object):

    def talk(self):
        print('ao ao')

class cat(animal):

    def talk(self):
        print('miao miao')

class sheep(animal):

    def foo():
        print('just for foo')
#'''
    def talk(self):
        print('mie mie')
#'''

class new_animal(cat, sheep):

    def foo():
        print('go go')
'''
    def talk(self):
        print('wo wo wo')
'''
a = new_animal()
a.talk()


