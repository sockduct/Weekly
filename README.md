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

### Week 6, Ending December 25, 2020 - TBD...

<hr>
<br>
<hr>

## License

[MIT License](LICENSE)
<hr>
