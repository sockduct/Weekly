def nbMonths(startPriceOld, startPriceNew, savingperMonth, percentLossByMonth):
    saved = 0
    monthsElapsed = 0
    currentPriceOld = startPriceOld
    currentPriceNew = startPriceNew

    while True:
        if (currentPriceOld + saved) >= currentPriceNew:
            return [monthsElapsed, round(currentPriceOld + saved - currentPriceNew)]
        monthsElapsed += 1
        saved += savingperMonth
        if (monthsElapsed % 2) == 0:
            percentLossByMonth += 0.5
        currentPriceOld -= (currentPriceOld * percentLossByMonth/100)
        currentPriceNew -= (currentPriceNew * percentLossByMonth/100)

def test():
    assert nbMonths(2000, 8000, 1000, 1.5) == [6, 766]
    assert nbMonths(12000, 8000, 1000, 1.5) == [0, 4000]

if __name__ == '__main__':
    test()
