function get-factorial([long]$n) {
    if ($n -lt 0) {
        return $null
    } elseif ($n -le 1) {
        return 1
    }

    [bigint]$res = 1
    for ($i = 2; $i -le $n; $i++) {
        $res *= $i
    }
    return $res
}

function get-combinations([long]$n1, [long]$n2) {
    if ($n1 -lt 0 -or $n2 -lt 0) {
        return $null
    } elseif ($n1 -eq $n2) {
        return 1
    }

    [bigint]$res = 1
    [long]$ndiff = $n1 - $n2
    # Optimize using:
    # C(m, n) = (m * m-1 * m-2 ... * m - n + 1)/(n!)
    # Required because tests overflow int64
    for ($i = $n1; $i -gt $n2; $i--) {
        $res *= $i
    }

    if ($n2 -ge $ndiff) {
        return [long]($res/(get-factorial $n2))
    } else {
        return [long]($res/(get-factorial $ndiff))
    }
}

function check-choose([long]$m, [int]$n) {
    if ($m -lt 0 -or $n -lt 1) {
        return $null
    }

    [bigint]$res = 0
    for ($i = 0; $i -le $n; $i++) {
        $res = get-combinations $n $i
        if ($res -eq $m) {
            return $i
        }
    }

    return -1
}

function check-test($a, $b, $c) {
    $ans = check-choose $a $b
    if ($ans -ne $c) {
        Write-Output "Dooh!  check-choose($a, $b) -> $ans, not $c"
        Exit 1
    } else {
        Write-Output "Woo Hoo!"
    }
}

# Main testing logic:
check-test 6 4 2
check-test 4 4 1
check-test 4 2 -1
check-test 35 7 3
check-test 36 7 -1
check-test 47129212243960 50 20
check-test 47129212243961 50 -1
#check-test 9223372036854735203 2147480602 -1
