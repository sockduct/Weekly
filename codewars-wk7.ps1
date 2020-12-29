function comp($a1, $a2) {
    if ($null -eq $a1 -or $null -eq $a2) {
        return $false
    } elseif ($a1.length -ne $a2.length) {
        return $false
    } elseif ($a1.length -eq 0 -and $a2.length -eq 0) {
        return $true
    }

    $tracker = @{}
    foreach ($e in $a2) {
        if ($tracker.Contains($e)) {
            $tracker[$e] += 1
        } else {
            $tracker[$e] = 1
        }
    }

    foreach ($e in $a1) {
        $e2 = $e * $e
        if ($tracker.Contains($e2) -and $tracker[$e2] -gt 0) {
            $tracker[$e2] -= 1
        } else {
            return $false
        }
    }

    return $true
}

$a1 = 121, 144, 19, 161, 19, 144, 19, 11
$a2 = 11, 121, 144, 19, 161, 19, 144, 19
for ($i = 0; $i -lt $a2.Length; $i++) {
    $a2[$i] *= $a2[$i]
}
if (comp($a1, $a2) -ne $true) {
    Write-Output "Doooh!"
} else {
    Write-Output "Woo Hoo!"
}

$a1 =  121, 144, 19, 161, 19, 144, 19, 11 
$a2 =  14641, 20736, 361, 25921, 361, 20736, 361, 121
$ans = comp $a1 $a2
if ($ans -ne $true) {
    Write-Output "Doooh!"
} else {
    Write-Output "Woo Hoo!"
}
