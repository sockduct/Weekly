# PowerShell Script
#
# Take ADUser object and nicely format important properties
#
# Author:  James R. Small
# Version:  1.0
# Last Updated:  01-16-2021-01
#
# To Do:
# * Handle case where no argument passed - Usage message?
# * Check if Microsoft Active Directory Module present and handle if not
# * Should I import the Microsoft AD Module before using its types?
# * Check if property supplied with user - if not, don't display
# * Handle if ADUser piped in
#

#
# Warning - don't send in an ADUser that's been through select-object
# Otherwise you'll get a can't convert from
# "Selected.Microsoft.ActiveDirectory.Management.ADUser" to the type below:
param (
    [Microsoft.ActiveDirectory.Management.ADUser]$user
)

function Write-ADUser {
    param (
        [Microsoft.ActiveDirectory.Management.ADUser]$user
    )


    $expiration = [datetime]::FromFileTime($user.'msDS-UserPasswordExpiryTimeComputed')

    <# Enabled | LockedOut | PasswordExpired | Status | Description
       ====================================================================
        True   |   True    |    True         | Red    | LockedOut
        True   |   True    |    False        | Red    | LockedOut
        True   |   False   |    True         | Yellow | PasswordExpired
        True   |   False   |    False        | Green  | All good
        False  |   True    |    True         | Red    | Disabled, LockedOut
        False  |   True    |    False        | Red    | Disabled, LockedOut
        False  |   False   |    True         | Red    | Disabled
        False  |   False   |    False        | Red    | Disabled
    #>
    if ($user.enabled -and !$user.lockedout -and !$user.passwordexpired) {
        $color = "green"
    } elseif ($user.enabled -and !$user.lockedout -and $user.passwordexpired) {
        $color = "yellow"
    } else {
        $color = "red"
    }
    Write-Host ("         Display Name:  {0}" -f $user.DisplayName) -ForegroundColor $color
    Write-Host ("   Distinguished Name:  {0}" -f $user.DistinguishedName) -ForegroundColor blue
    if ($user.enabled -eq $false) {
        $color = "red"
    } else {
        $color = "green"
    }
    Write-Host ("      Account Enabled:  {0}" -f $user.Enabled) -ForegroundColor $color
    if ($user.lockedout -eq $false) {
        $color = "green"
    } else {
        $color = "red"
    }
    Write-Host ("   Account Locked Out:  {0}" -f $user.LockedOut) -ForegroundColor $color
    if ($user.passwordexpired -eq $false) {
        $color = "green"
    } else {
        $color = "red"
    }
    Write-Host ("     Password Expired:  {0}" -f $user.PasswordExpired) -ForegroundColor $color
    Write-Host ("Date Password Expires:  {0}" -f $expiration)
    Write-Host ("      Last Logon Date:  {0}" -f $user.LastLogonDate)
    Write-Host ("       E-mail Address:  {0}" -f $user.EmailAddress)
    Write-Host ("     SAM Account Name:  {0}" -f $user.SamAccountName)
    Write-Host ("  User Principal Name:  {0}" -f $user.UserPrincipalName)
}

Write-ADUser $user
