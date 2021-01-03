function RowSumOddNumbers([int] $n) {
  # Odd number:  2n - 1
  # Sum of first n odds = n^2
  # Sum of first n numbers = n(n + 1)/2
  
  # Start of row $n:
  $before = ($n * ($n - 1))/2
  $rowend = $before + $n
  
  $rowend * $rowend - $before * $before
}

function testfunc() {
    $expected = [ordered]@{ 1 = 1; 2 = 8; 13 = 2197; 19 = 6859; 41 = 68921; 42 = 74088;
                            74 = 405224; 86 = 636056; 93 = 804357; 101 = 1030301 }
    
    foreach ($k in $expected.keys) {
        $res = RowSumOddNumbers $k
        if ($res -ne $expected.$k) {
            Write-Output ("Fail:  Expected RowSumOddNumbers($k) -> {0}, got $res." -f $expected.$k)
        } else {
            Write-Output "Pass"
        }
    }
}

testfunc
