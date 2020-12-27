function game($n) {
    $matrix = $n * $n

    if (($matrix % 2) -eq 0) {
        $matrix /= 2
        return "[$matrix]"
    } else {
        return "[$matrix, 2]"
    }
}
