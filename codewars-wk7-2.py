def factorial(n):
    if n < 0:
        raise ValueError('n must be >= 0')
    elif n <= 1:
        return 1
    
    res = 1
    for i in range(2, n + 1):
        res *= i
    
    return res

def combinations(n, k):
    if n < 0 or k < 0:
        raise ValueError('n and k must be >= 0')
    elif n == k:
        return 1
    
    res = 1
    nkdiff = n - k

    for i in range(n, k, -1):
        res *= i
    
    if (k >= nkdiff):
        return res//factorial(k)
    else:
        return res//factorial(nkdiff)

def checkchoose(m, n):
    if m < 0 or n < 1:
        raise ValueError('m must be >= 0, n >= 1')
    
    res = 0
    for i in range(0, n + 1):
        res = combinations(n, i)
        if res == m:
            return i
    
    return -1

def testsol():
    assert checkchoose(6, 4) == 2
    assert checkchoose(4, 4) == 1
    assert checkchoose(4, 2) == -1
    assert checkchoose(35, 7) == 3
    assert checkchoose(36, 7) == -1
    assert checkchoose(47129212243960, 50) == 20
    assert checkchoose(47129212243961, 50) == -1
    assert checkchoose(1, 11) == 0
    assert checkchoose(1304321660884209177810600, 143) == 20

if __name__ == '__main__':
    testsol()
