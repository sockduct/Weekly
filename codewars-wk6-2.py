#! /usr/bin/env python3

from fractions import Fraction
from functools import reduce
from itertools import repeat
from math import gcd
from time import perf_counter_ns

# Note: Accurate, but slow
def game_frac(n):
    # Sanity check:
    if n < 0:
        raise ValueError(f'n must be >= 0, but {n} was passed.')

    # matrix = []
    # total = 0.0
    total = Fraction()
    for row_denom in range(1, n + 1):
        # cur_row = []
        for col_num in range(1, n + 1):
            # cur_row.append(Fraction(col_num, row_denom + col_num))
            # total += col_num/float(row_denom + col_num)
            total += Fraction(col_num, row_denom + col_num)
        # matrix.append(cur_row)
    # return matrix
    if total.numerator == 0:
        return [0]
    elif total.denominator == 1:
        return [total.numerator]
    else:
        # as_integer_ratio method requires v3.8+
        # Otherwise:
        # return [total.numerator, total.denominator]
        return list(total.as_integer_ratio())

def game2(n):
    numerator = 0
    denominator = 1

    for row_denom in range(1, n + 1):
        # row = [Fraction(col_num, row_denom + col_num) for col_num in range(1, n + 1)]
        cur_row_nums = [col_num for col_num in range(1, n + 1)]
        cur_row_denoms = [row_denom + col_num for col_num in range(1, n + 1)]
        lmult = reduce(lcm, cur_row_denoms)
        cur_row_lcm = repeat(lmult, n)
        cur_row_pairs = map(lambda ndl: (ndl[0] * (ndl[2]//ndl[1]), ndl[2]), zip(cur_row_nums, cur_row_denoms, cur_row_lcm))
        cur_row_pair = reduce(lambda f1, f2: (f1[0] + f2[0], f1[1]), cur_row_pairs)
        numerator, denominator = add_fractions(numerator, denominator, cur_row_pair[0], cur_row_pair[1])

    divisor = gcd(numerator, denominator)
    if divisor > 1:
        numerator //= divisor
        denominator //= divisor

    if numerator == 0 or denominator == 1:
        return [numerator]
    else:
        return [numerator, denominator]

def game3(n):
    numerator = 0
    denominator = 1

    rowres = []
    for row_denom in range(1, n + 1):
        # row = [Fraction(col_num, row_denom + col_num) for col_num in range(1, n + 1)]
        cur_row_nums = [col_num for col_num in range(1, n + 1)]
        cur_row_denoms = [row_denom + col_num for col_num in range(1, n + 1)]
        lmult = reduce(lcm, cur_row_denoms)
        cur_row_lcm = repeat(lmult, n)
        cur_row_pairs = map(lambda ndl: (ndl[0] * (ndl[2]//ndl[1]), ndl[2]), zip(cur_row_nums, cur_row_denoms, cur_row_lcm))
        # cur_row_pair = reduce(lambda f1, f2: (f1[0] + f2[0], f1[1]), cur_row_pairs)
        # numerator, denominator = add_fractions(numerator, denominator, cur_row_pair[0], cur_row_pair[1])
        rowres.append(reduce(lambda f1, f2: (f1[0] + f2[0], f1[1]), cur_row_pairs))
    
    lmult = reduce(lcm, [d for n, d in rowres])
    rowres_lcm = repeat(lmult, n)
    rowres_pairs = map(lambda ndl: (ndl[0][0] * (ndl[1]//ndl[0][1]), ndl[1]), zip(rowres, rowres_lcm))
    numerator, denominator = reduce(lambda f1, f2: (f1[0] + f2[0], f1[1]), rowres_pairs)

    divisor = gcd(numerator, denominator)
    if divisor > 1:
        numerator //= divisor
        denominator //= divisor

    if numerator == 0 or denominator == 1:
        return [numerator]
    else:
        return [numerator, denominator]

# Note:  Included in math library in v3.9+
def lcm(a, b):
    return (a * b)//gcd(a, b)

def add_fractions(num1, denom1, num2, denom2):
    lmult = lcm(denom1, denom2)

    new_denom = lmult
    new_num = num1 * (lmult//denom1)
    new_num += (num2 * (lmult//denom2))

    return new_num, new_denom

# Faster
def game1(n):
    numerator = 0
    denominator = 1

    for row_denom in range(1, n + 1):
        for col_num in range(1, n + 1):
            numerator, denominator = add_fractions(numerator, denominator,
                                                   col_num, row_denom + col_num)
    
    divisor = gcd(numerator, denominator)
    if divisor > 1:
        numerator //= divisor
        denominator //= divisor

    if numerator == 0 or denominator == 1:
        return [numerator]
    else:
        return [numerator, denominator]

# Clever solution based on realizing that all the diagonal pairs add up to 1
def game(n):
    matrix = n * n
    
    if (matrix % 2) == 0:
        return [matrix/2]
    else:
        return [matrix, 2]

def nstimer(f, arg):
    start = perf_counter_ns()
    f(arg)
    stop = perf_counter_ns()

    print(f'{f.__name__}({arg}) took {(stop - start)/10**9:0.4f} seconds')

def unit_test():
    # assert game(0) == 0
    assert game(0) == [0]
    # assert game(1) == 0.5
    assert game(1) == [1, 2]
    assert game(8) == [32]

    # assert game_frac(128) == game(128)
    # assert game(8) == game2(8)

    # nstimer(game_frac, 256)
    # nstimer(game, 512)
    # nstimer(game2, 512)
    # nstimer(game3, 512)

if __name__ == '__main__':
    unit_test()
