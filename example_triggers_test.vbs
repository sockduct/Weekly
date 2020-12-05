'
' AnyConnect OnConnect Script using vbscript - "example_triggers_test.vbs"
'
'        Author:  James Small
'       Version:  1.32
' Last Modified:  12/4/2020
'
' Purpose:  For Example1 managed systems with an Example1 user logged in, trigger Group
'           Policy update with gpupdate.  This is necessary as remote systems
'           don't have access to Example1 Domain Controllers upon bootup and initial
'           user login.  This triggers the update upon successful VPN connection
'           as Domain Controllers are then reachable by the system.
'
' Issues:
' 1) Some antivirus/antimalware/endpoint security solutions may block or
'    interfere with this script.
'

ON ERROR RESUME NEXT
Err.Clear

Function IsBlank(Value)
    ' Returns True if Empty or NULL or Zero
    If IsEmpty(Value) or IsNull(Value) Then
        IsBlank = True
    ElseIf VarType(Value) = vbString Then
        If Value = "" Then
            IsBlank = True
        End If
    ElseIf IsObject(Value) Then
        If Value Is Nothing Then
            IsBlank = True
        End If
    ElseIf IsNumeric(Value) Then
        If Value = 0 Then
            IsBlank = True
        End If
    Else
        IsBlank = False
    End If
End Function

Function GetADUser(strUser, strDomain) 
    Const ADS_SCOPE_SUBTREE = 2 
     
    Set objConnection = createObject("ADODB.Connection") 
    Set objCommand = createObject("ADODB.Command") 
    objConnection.Provider = "ADsDSOObject" 
    objConnection.Open "Active Directory Provider" 
     
    Set objCOmmand.ActiveConnection = objConnection 
    objCommand.CommandText = "SELECT " & _
        "DisplayName, DistinguishedName, Mail, HomeDirectory, " & _
        "HomeDrive, sAMAccountName, UserPrincipalName " & _
        "FROM 'LDAP://" & strDomain & "' WHERE sAMAccountName='" & strUser & "'" 
    objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE  
    Set usrObj = objCommand.Execute 

    If usrObj.RecordCount = 0 Then
        GetADUser = False
        strMessage = strMessage & "Account ``" & struser & _
            "'' not found in domain ``" & strComputerDomain & "''" & vbCrLf
    ElseIf UsrObj.RecordCount > 1 Then
        GetADUser = False
        strMessage = strMessage & "Error:  More than 1 match - " & _
            "should not be possible..." & vbCrLf
    Else
        GetADUser = True

        ' Tried returning usrObj, but it didn't work so stuffing values into a
        ' global dictionary:
        dictADUser.Add "DisplayName" = usrObj.Fields("DisplayName")
        dictADUser.Add "DN" = usrObj.Fields("DistinguishedName")
        dictADUser.Add "SAMAccount" = usrObj.Fields("sAMAccountName")
        dictADUser.Add "UPN" = usrObj.Fields("UserPrincipalName")
        dictADUser.Add "Email" = usrObj.Fields("Mail")
        dictADUser.Add "HomeDir" = usrObj.Fields("HomeDirectory")
        dictADUser.Add "HomeDrv" = usrObj.Fields("HomeDrive")
        
        For Each Key In dictADUser.Keys
            If IsBlank(dictADUser(Key)) Then
                dictADUser(Key) = "<Not Set>"
            End If
        Next

        strMessage = strMessage & "Found account ``" & struser & _
            "'' in domain ``" & strDomain & "''" & vbCrLf & _
            "Display Name:  " & dictADUser("DisplayName") & vbCrLf & _
            "Distinguished Name:  " & dictADUser("DN") & vbCrLf & _
            "sAMAccountName:  " & dictADUser("SAMAccount") & vbCrLf & _
            "User Principal Name:  " & dictADUser("UPN") & vbCrLf & _
            "E-mail Address:  " & dictADUser("Email") & vbCrLf & _
            "Home Directory:  " & dictADUser("HomeDir") & vbCrLf & _
            "Home Drive:  " & dictADUser("HomeDrv") & vbCrLf
    End If

End Function 

Function Example1UserSystem()
    ' Get Username:
    strUser = CreateObject("WScript.Network").UserName
    strMessage = "Username:  " & strUser & vbCrLf

    ' Check User Domain:
    Set objSysInfo = CreateObject("WinNTSystemInfo")
    strUserDomain = objSysInfo.DomainName
    strMessage = strMessage & "User Domain:  " & strUserDomain & vbCrLf

    ' Example1 User?
    If LCase(strUserDomain) = "example1" or LCase(strUserDomain) = "example2" Then
        boolExample1User = True
        strMessage = strMessage & "User in Example1 Domain (check 1 passed)" & vbCrLf
    Else
        boolExample1User = False
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

    ' Example1 system?
    If LCase(strComputerDomain) = "example1.org" Or LCase(strComputerDomain) = "example2.org" Then
        boolExample1System = True
        strMessage = strMessage & "System in Example1 Domain (check 2 passed)" & vbCrLf
    Else
        boolExample1System = False
        strMessage = strMessage & "System not in eligible Domain (check 2 failed)" & vbCrLf
    End If

    ' Example1 user on Example1 system in the Active Directory Domain?
    If boolExample1User = True And boolExample1System = True And boolInDomain = True Then
        strMessage = strMessage & "User & System in Example1 managed Domain (check 3 passed)" & vbCrLf
        Example1UserSystem = True
    Else
        strMessage = strMessage & "User & System not in eligible (managed) Domain " _
                     & "(check 3 failed)" & vbCrLf
        Example1UserSystem = False
    End If
End Function

Function ValidUserContainer(strUserDN, strOrg)
    ' Check if user in correct OU:
    strUserOU = Mid(strUserDN, InStr(strUserDN, ",") + 1)
    strMessage = strMessage & "User OU:  " & strUserOU & vbCrLf

    Select Case strOrg
        Case Example2
            If LCase(strUserOU) = "ou=example2-users,ou=user accounts,dc=example2,dc=org" Then
                ValidUserContainer = True
                strMessage = strMessage & "User in correct Example2 container - Example2-Users " _
                            & "(check 4 passed)" & vbCrLf
            Else
                ValidUserContainer = False
                strMessage = strMessage & "User not in eligible Example2 container - Example2-Users " _
                            & "(check 4 failed)" & vbCrLf
            End If
        Case Example1
            If LCase(strUserOU) = "ou=example1-users,ou=user accounts,dc=example1,dc=org" or _
                    LCase(strUserOU) = "ou=example1-users,ou=user accounts,dc=example2,dc=org" Then
                ValidUserContainer = True
                strMessage = strMessage & "User in correct Example1 container - Example1-Users " _
                            & "(check 4 passed)" & vbCrLf
            Else
                ValidUserContainer = False
                strMessage = strMessage & "User not in eligible Example1 container - Example1-Users " _
                            & "(check 4 failed)" & vbCrLf
            End If
        Case Else
            ValidUserContainer = False
            strMessage = strMessage & "Unknown Org ``" & strOrg & "'' - user " & _
                         "eligibility not checked (check 4 failed)" & vbCrLf
    End Select
End Function


Set objShell = CreateObject("WScript.Shell")
strEventLog1 = "Example1 AnyConnect OnConnect Script - Group Policy Trigger"
'''objShell.LogEvent 0, strEventLog1
' Declare globally to accrue status information:
Dim strMessage
Dim strUser
Dim strComputerDomain
Dim dictADUser
Set dictADUser = CreateObject("Scripting.Dictionary")

If Example1UserSystem Then
    validADUser = GetADUser(strUser, strComputerDomain)

    If validADUser Then
        ValidExample1User = False
        ValidExample2User = False
        If ValidUserContainer(dictADUser("DN"), "Example1") Then
            ValidExample1User = True
        ElseIf ValidUserContainer(dictADUser("DN"), "Example2") Then
            ValidExample2User = True
        End If

        If ValidExample1User Then
            strMessage = strMessage & "Eligible Example1 User & System - Group Policy Update" & vbCrLf

            ' Refreshes local and Active Directory-based Group Policy settings, including security settings
            ' For debugging and to disable gpupdate:
            returnCode = 0
            '''returnCode = objShell.Run("gpupdate.exe /force", 0, True)
            ' Note - above runs synchronously, script won't progress until it finishes.

            If returnCode <> 0 Then
                strError = "Group Policy Update resulted in an error code of " _
                           & returnCode & "."
                '''objShell.LogEvent 2, strError & vbCrLf & vbCrLf & "Eligibility criteria:" & vbCrLf _
                '''                     & strMessage
                strMessage = strMessage & vbCrLf & strError
            Else
                strSuccess = "Group Policy Update triggered successfully."
                '''objShell.LogEvent 0, strSuccess & vbCrLf & vbCrLf & "Eligibility criteria:" & vbCrLf _
                '''                     & strMessage
                strMessage = strMessage & vbCrLf & strSuccess
            End If
        ' Could add ValidExample2User section here if needed...
        Else
            strMessage = strMessage & "Ineligible Example1 User & System - Group Policy Update" & vbCrLf
        End If

        If ValidExample2User Or ValidExample1User Then
            strMessage = strMessage & "Eligible Example2/Example1 User & System - Drive Mappings" & vbCrLf

            ' Map Drives
            Set objNetwork = WScript.CreateObject("WScript.Network")
            ' Need to check for errors or if drive already mapped...
            objNetwork.MapNetworkDrive "Z:", "\\homemaster.example1.org\data", True

            strMessage = strMessage & "Mapped Z: drive" & vbCrLf

            If dictADUser("HomeDir") <> "<Not Set>" and dictADUser("HomeDrv") <> "<Not Set>" Then
                objNetwork.MapNetworkDrive dictADUser("HomeDrv"), dictADUser("HomeDir"), True
                strMessage = strMessage & "Valid home drive and home directory configured - " & _
                             "Mapped " & dictADUser("HomeDrv") & " to " & dictADUser("HomeDir") & vbCrLf
            End If
        Else
            strMessage = strMessage & "Ineligible Example2/Example1 User & System - Drive Mappings" & vbCrLf
        End If
    End If
Else
    strEventLog2 = "User/System not eligible - no action taken."
    '''objShell.LogEvent 0, strEventLog2 & vbCrLf & vbCrLf & "Eligibility criteria:" & vbCrLf _
    '''                     & strMessage
    strMessage = strMessage & vbCrLf & strEventLog2
End If

' For debugging - provide feedback in message box at end of script:
WScript.Echo " -= " & strEventLog1 & " =- " & vbCrLf & vbCrLf & strMessage
' Uncomment above for interactive runs

WScript.Quit
