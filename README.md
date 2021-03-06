# Weekly Projects Dashboard

<br>
<hr>

## [Weekly Projects Wiki](../../wiki)

<hr>
<br>
<hr>

## Weekly Projects

<hr>

### Week 1, Ending November 20, 2020

* [example_gptrigger.vbs](example_gptrigger.vbs) - This script is designed to run from [Cisco's AnyConnect VPN Client](https://www.cisco.com/c/en/us/support/security/anyconnect-secure-mobility-client-v4-x/model.html).  Upon connection to the VPN Concentrator, the script is downloaded to the client and executed.  This particular script is designed to check if the user and system are part of Example (fictitious organization).  If yes, and the user is in the correct container then a group policy update is initiated and its status recorded.  Detailed logging is kept allowing examination of the application event log to determine why a user & system were or weren't eligible.

### Week 2, Ending November 27, 2020 - Epic Fail...

* Nothing!!! :-(

### Week 3, Ending December 4, 2020

* [example_triggers_test.vbs](example_triggers_test.vbs) - This is an enhancement of week 1's script.  In addition to running group policy updates, this script adds support for mapping drives.  It also supports two different organizations which are split between two different Active Directory Domains/Forests.  In order to support more options and multiple organizations I tried to better modularize the code.  Instead of GetUserDN which retrieves a specific attribute for a user, there's now GetADUser which retrieves a list of attributes.  I couldn't figure out how to return the result object so I created a dictionary to hold the attributes.  I believe this function is also more efficient than GetUserDN as it queries using a unique property so only one (or none) user should be returned and thus there's no need to iterate.  Instead, we just check the record count.  In addition, the main logic tries to be more general to support things just for the organization Example1, just things for the organization Example2, and things both have in common.  The comments/logging were also enhanced to provided detailed information on what's going on and why decisions were made.

### Week 4, Ending December 11, 2020 - Found a site with PowerShell coding challenges

* [codewars-wk4.py](codewars-wk4.py) - [Codewars](https://www.codewars.com) kata - bouncing balls (Python solution)
* [codewars-wk4.ps1](codewars-wk4.ps1) - [Codewars](https://www.codewars.com) kata - bouncing balls (PowerShell solution), this is my attempt to start writing PowerShell code on a regular basis.  I don't know how to think in PowerShell yet so I actually wrote the solution and tests in Python.  Then I ported the solution with Google-Fu to PowerShell.  This makes me realize how much I have to learn about PowerShell, but at least it's pushing me in the right direction.

### Week 5, Ending December 18, 2020 - Finish up school project and collect templates I use for assignments

* [lookup.sh](../../../Example-Code/blob/master/lookup.sh) - Complete class assignment using bash script, an address book program
* [Templates - Linux](../../../Templates.Linux) - Code templates targeting Linux including C, C++, bash scripts, a Makefile, a recorder script, and a source code file to markdown converter

### Week 6, Ending December 25, 2020 - Keep doing PowerShell coding challenges

* [codewars-wk6.py](codewars-wk6.py) - [Codewars](https://www.codewars.com) kata - buying a car (Python solution)
* [codewars-wk6.ps1](codewars-wk6.ps1) - [Codewars](https://www.codewars.com) kata - buying a car (PowerShell solution), continuing to develop my working PowerShell knowledge.  This week I realize that PowerShell is quite a bit different than traditional programming languages, but also quite similar to another shell - bash!
* [codewars-wk6-2.py](codewars-wk6-2.py) - [Codewars](https://www.codewars.com) kata - playing on a chessboard (Python solution)
  * [How to find formula for generic summation n/(n + C)](https://math.stackexchange.com/q/3959180/866013) - My attempt to find a formula/algorithm to calculate the sequence/matrix.  In the process I found the solution myself.  :-)  [Rubber duck debugging](https://en.wikipedia.org/wiki/Rubber_duck_debugging) to the rescue once again...
  * [fracgrid.py](fracgrid.py) - Helper program to print out a matrix of incrementing fractions
  * [matrices.xlsx](matrices.xlsx) - Spreadsheet to play around with matrices to help see/find solution for this challenge
* [codewars-wk6-2.ps1](codewars-wk6-2.ps1) - [Codewars](https://www.codewars.com) kata - playing on a chessboard (PowerShell solution)
* [codewars-wk6-2.cpp](codewars-wk6-2.cpp) - [Codewars](https://www.codewars.com) kata - playing on a chessboard (C++ attempt)

### Week 7, Ending January 1, 2021 - Keep doing PowerShell coding challenges

* [codewars-wk7.py](codewars-wk7.py) - [Codewars](https://www.codewars.com) kata - are they the "same" (Python solution)
* [codewars-wk7.ps1](codewars-wk7.ps1) - [Codewars](https://www.codewars.com) kata - are they the "same" (PowerShell solution), discovered there's a much simpler PowerShell solution:  ```compare-object @($a1 | % {$_ * $_}) $a2```.  Also learning quite a bit trying to translate Python into PowerShell.  There's still a lot I don't know how to do in PowerShell.  For this solution I tried to do ```if ($element -in $hashtable) {...}``` - a direct translation from Python, except it doesn't work!  In PowerShell, you need to do ```if ($hashtable.contains($element)) {...}```.  It also appears $null in PowerShell is not quite the same as None in Python...
* [codewars-wk7-2.ps1](codewars-wk7.ps1) - [Codewars](https://www.codewars.com) kata - color choice (PowerShell solution), this week I started in PowerShell!  Finally getting comfortable tackling problems directly in PowerShell...  Definitely different from general purpose programming language like Python - much more like bash.  For example, functions are invoked function arg1 arg2 arg3 not function(arg1, arg2, arg3).  Doing the latter results in passing an array to the function!!!  However, I couldn't solve the problem with PowerShell and had to switch to Python.  This problem appeared to require arbitrarily large integers.  Python supports this natively, PowerShell supports this with the bigint type which doesn't appear to be easily discoverable.
* [codewars-wk7-2.py](codewars-wk7.py) - [Codewars](https://www.codewars.com) kata - color choice (Python solution), Python is just great.  In fact, it turns out that the Python math library (part of stdlib) includes a factorial function - so I didn't even have to write that...  It's worth noting, PowerShell functionality for codewars is marked beta.  I noticed that the Python support is much better.  The test cases for example are far more ellaborate and provide much better feedback.  This makes it much easier to find problems with Python for codewars.

### Week 8, Ending January 8, 2021 - Continue to build out PowerShell skills, started developing production grade PowerShell script

* [codewars-wk8.ps1](codewars-wk8.ps1) - [Codewars](https://www.codewars.com) kata - sum of odd numbers (PowerShell solution), started and actually completed this challenge all in PowerShell.  This one was good for improving my understanding of PowerShell's implementation of "hash tables."  While it's similar to a dictionary in Python, the access method is a little different.  I also used an ordered hash table to facilitate testing.  I actually like this better than what the site did.
* Working on production utility script to check multiple Active Directories (in separate Forests) for a specific user account, the account's validity, and if the account has the necessary requirements to use VPN

### Week 9, Ending January 15, 2021 - Hitting my stride with PowerShell, continue work on production grade script

* [Write-ADUser.ps1](Write-ADUser.ps1) - A function that came out of my production grade script as it's a useful standalone component

### Week 10, Ending January 22, 2021 - Used PowerShell this week to sift through Windows Event Logs and find cause instigating service crash.  Created a simple Python program - simple if you understand permutations and leveraging data structures.  This is something I've always wanted to do and finally got around to it.

* [letters2words.py](letters2words.py) - Simple Python program to find all possible words from set of letters, written as I started playing Scrabble and word games.

### Week 11, Ending January 29, 2021 - Heads down in Django for the whole week.  Working through Django for Beginners - past half way through the book now.  Also putting together project design plan for my senior/capstone project.  My Django commits this week are all private, but once I work out security I can make the repos public.

### Week 12, Ending February 5 2021 - TBD...

<hr>
<br>
<hr>

## License

[MIT License](LICENSE)
<hr>
