#!/usr/bin/python

def do_something(p1,p2):
    print(type(p1))
    print(type(p2))

def do_something_else(p1,p2):
    c = int(p1) + int(p2)
    print(c)

if __name__ == '__main__':
    do_something(4,'hello')
    do_something_else(5,6)
