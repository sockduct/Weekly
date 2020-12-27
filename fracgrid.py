#! /usr/bin/env python3

import sys

def fracgrid(n):
    for row in range(1, n + 1):
        for col in range(1, n + 1):
            print(f'{col}/{col + row}\t', end='')
        print()

if __name__ == '__main__':
    fracgrid(int(sys.argv[1]))
