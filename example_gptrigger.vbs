'
' AnyConnect OnConnect Script using vbscript - "example_gptrigger.vbs"
'
'        Author:  James Small
'       Version:  1.23
' Last Modified:  11/20/2020
'
' Purpose:  For Example managed systems with an Example user logged in, trigger
'           Group Policy update with gpupdate.  This is necessary as remote
'           systems don't have access to Example Domain Controllers upon bootup
'           and initial user login.  This triggers the update upon successful
'           VPN connection as Domain Controllers are then reachable by the
'           system.
'
' Issues:
' 1) Some antivirus/antimalware/endpoint security solutions may block or
'    interfere with this script.
'

ON ERROR RESUME NEXT
Err.Clear

Public Function GetUserDN(strUser, strDomain) 
    Const ADS_SCOPE_SUBTREE = 2 
     
    Set objConnection = createObject("ADODB.Connection") 
    Set objCommand = createObject("ADODB.Command") 
    objConnection.Provider = "ADsDSOObject" 
    objConnection.Open "Active Directory Provider" 
     
    Set objCOmmand.ActiveConnection = objConnection 
    objCommand.CommandText = _ 
        "Select distinguishedname, Name, Location from 'LDAP://" & strDomain & _ 
        "' Where objectClass='user' and samaccountname='" & strUser & "'" 
    objCommand.Properties("Page Size") = 1000 
    objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE  
    Set objRecordSet = objCommand.execute 
    objRecordSet.MoveFirst 
     
    Do Until objRecordSet.EOF 
        GetUserDN = objRecordSet.Fields("distinguishedname") 
        objRecordSet.MoveNext 
    Loop 
End Function 

Public Function GroupPolicyUser()
    ' Get Username:
    strUser = CreateObject("WScript.Network").UserName
    strMessage = "Username:  " & strUser & vbCrLf

    ' Check User Domain:
    Set objSysInfo = CreateObject("WinNTSystemInfo")
    strUserDomain = objSysInfo.DomainName
    strMessage = strMessage & "User Domain:  " & strUserDomain & vbCrLf

    ' Example User?
    If LCase(strUserDomain) = "example" Then
        boolExampleUser = True
        strMessage = strMessage & "User in Example Domain (check 1 passed)" & vbCrLf
    Else
        boolExampleUser = False
        strMessage = strMessage & "User not in eligible Domain (check 1 failed)" & vbCrLf
    End If

    ' Check System Domain:
    Set objWMISvc = GetObject("winmgmts:\\.\root\cimv2")
    Set colItems = objWMISvc.ExecQuery("Select * from Win32_ComputerSystem")
    For Each objItem in colItems
        strComputerDomain = objItem.Domain
        If objItem.PartOfDomain Then
            boolInDomain = True
            strMessage = strMessage & "Computer Domain:  " & strComputerDomain & vbCrLf
        Else
            boolInDomain = False
            strMessage = strMessage & "Workgroup:  " & strComputerDomain & vbCrLf
        End If
    Next

    ' Example system?
    If LCase(strComputerDomain) = "example.org" Then
        boolExampleSystem = True
        strMessage = strMessage & "System in Example Domain (check 2 passed)" & vbCrLf
    Else
        boolExampleSystem = False
        strMessage = strMessage & "System not in eligible Domain (check 2 failed)" & vbCrLf
    End If

    ' Example user on Example system in the Active Directory Domain?
    If boolExampleUser = True And boolExampleSystem = True And boolInDomain = True Then
        strMessage = strMessage & "User & System in Example managed Domain (check 3 passed)" & vbCrLf
        ' Check if user in correct OU:
        strUserDN = GetUserDN(strUser, strComputerDomain)
        strUserOU = Mid(strUserDN, InStr(strUserDN, ",") + 1)
        strMessage = strMessage & "User DN:  " & strUserDN & vbCrLf _
                                & "User OU:  " & strUserOU & vbCrLf

        If LCase(strUserOU) = "ou=example-users,ou=user accounts,dc=example,dc=org" Then
            boolGPUser = True
            strMessage = strMessage & "User in correct Example container - Example-Users " _
                         & "(check 4 passed)" & vbCrLf
        Else
            boolGPUser = False
            strMessage = strMessage & "User not in eligible Example container - Example-Users " _
                         & "(check 4 failed)" & vbCrLf
        End If
    Else
        strMessage = strMessage & "User & System not in eligible (managed) Domain " _
                     & "(check 3 failed)" & vbCrLf
    End If
    If boolGPUser = True Then
        strMessage = strMessage & "Example User & System in the GPUpdate Group" & vbCrLf
        GroupPolicyUser = True
    Else
        strMessage = strMessage & "Not part of the GPUpdate Group." & vbCrLf
        GroupPolicyUser = False
    End If
End Function

Set objShell = CreateObject("WScript.Shell")
strEventLog1 = "Example AnyConnect OnConnect Script - Group Policy Trigger"
objShell.LogEvent 0, strEventLog1
' Declare globally to accrue status information:
Dim strMessage

If GroupPolicyUser = True Then
    ' Refreshes local and Active Directory-based Group Policy settings, including security settings
    returnCode = objShell.Run("gpupdate.exe /force", 0, True)
    ' Note - above runs synchronously, script won't progress until it finishes.

    If returnCode <> 0 Then
        strError = "Example eligible user & system - Group Policy Update resulted in an error code of " _
                   & returnCode & "."
        objShell.LogEvent 2, strError & vbCrLf & vbCrLf & "Eligibility criteria:" & vbCrLf _
                             & strMessage
        strMessage = strMessage & vbCrLf & strError
    Else
        strSuccess = "Example eligible user & system - Group Policy Update triggered successfully."
        objShell.LogEvent 0, strSuccess & vbCrLf & vbCrLf & "Eligibility criteria:" & vbCrLf _
                             & strMessage
        strMessage = strMessage & vbCrLf & strSuccess
    End If
Else
    strEventLog2 = "User/System not eligible - no action taken."
    objShell.LogEvent 0, strEventLog2 & vbCrLf & vbCrLf & "Eligibility criteria:" & vbCrLf _
                         & strMessage
    strMessage = strMessage & vbCrLf & strEventLog2
End If

' For debugging - provide feedback in message box at end of script:
''WScript.Echo " -= " & strEventLog1 & " =- " & vbCrLf & vbCrLf & strMessage
' Uncomment above for interactive runs

WScript.Quit
