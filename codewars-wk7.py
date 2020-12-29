from collections import Counter

def comp(array1, array2):
    if array1 is None or array2 is None:
        return False
    elif len(array1) != len(array2):
        return False
    elif len(array1) == 0 and len(array2) == 0:
        return True
    
    tracker = Counter(array2)
    for val in array1:
        valsq = val * val
        if valsq in tracker and tracker[valsq] > 0:
            tracker[valsq] -= 1
        else:
            return False
    
    return True

def testcomp():
    a1 = [121, 144, 19, 161, 19, 144, 19, 11]
    a2 = [11*11, 121*121, 144*144, 19*19, 161*161, 19*19, 144*144, 19*19]
    assert comp(a1, a2) == True

if __name__ == '__main__':
    testcomp()
