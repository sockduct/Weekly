function nb-months {
    [OutputType([string])]
    Param ([int]$startPriceOld, [int]$startPriceNew, [int]$savingperMonth, [double]$percentLossByMonth)

    $saved = 0
    $monthsElapsed = 0
    $currentPriceOld = $startPriceOld
    $currentPriceNew = $startPriceNew

    while ($true) {
        if (($currentPriceOld + $saved) -ge $currentPriceNew) {
            return "$monthsElapsed,$([math]::Round($currentPriceOld + $saved - $currentPriceNew))"
        }
        $monthsElapsed += 1
        $saved += $savingperMonth
        if (($monthsElapsed % 2) -eq 0) {
            $percentLossByMonth += 0.5
        }
        $currentPriceOld -= ($currentPriceOld * $percentLossByMonth/100)
        $currentPriceNew -= ($currentPriceNew * $percentLossByMonth/100)
    }
}

function test1 {
    if ((nb-months 2000, 8000, 1000, 1.5) -ne "6, 766") {
        Write-Output "Test 1 failed."
        return
    }
    if ((nb-months 12000, 8000, 1000, 1.5) -ne "0, 4000") {
        Write-Output "Test 2 failed."
        return
    }
}
