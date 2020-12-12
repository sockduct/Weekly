function bouncing-ball
{
    [OutputType([int])]
    Param ([double]$h, [double]$bounce, [double]$window)

    # your code
    if ( $h -le 0 -or $bounce -le 0 -or $bounce -ge 1 -or $window -ge $h ) {
        return -1
    }

    $count = 0
    while ( $h -gt $window ) {
        if ( $count % 2 -eq 1 ) {
            $count += 2
        } else {
            $count += 1
        }
        $h *= $bounce
    }

    return $count
}
