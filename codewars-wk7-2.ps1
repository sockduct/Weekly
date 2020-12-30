function get-factorial([long]$n) {
    if ($n -lt 0) {
        return $null
    } elseif ($n -le 1) {
        return 1
    }

    [long]$res = 1
    for ($i = 2; $i -le $n; $i++) {
        $res *= $i
    }
    return $res
}

function get-combinations([long]$n1, [long]$n2) {
    if ($n1 -lt 0 -or $n2 -lt 0) {
        return $null
    }

    # Need to optimize this
    $ndiff = $n1 - $n2
    # Instead of below, use shortcut:
    # C(m, n) = (m * m-1 * m-2 ... * m - n + 1)/(n!)
    return (get-factorial $n1)/((get-factorial $ndiff) * (get-factorial $n2))
}

function check-choose([long]$m, [int]$n) {
    if ($m -lt 0 -or $n -lt 1) {
        return $null
    }

    $res = 0
    for ($i = 1; $i -le $n; $i++) {
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
check-test 35 7 3
check-test 36 7 -1
