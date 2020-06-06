
# UPN with Admin in
Get-ADUser -Filter {Name -like "*admin*"}


# UPNs with Admin in, not logged in for 2 years
Get-ADUser -Filter {Name -like "*admin*"} -Properties Name, UserPrincipalname, PasswordLastSet, LastLogonDate | Select Name, UserPrincipalname,PasswordLastSet, LastLogonDate | Where-Object {$_.LastLogonDate -notlike "*2020*" -and $_.LastLogonDate -notlike "*2019*"}


# UPNs with Admin in but disabled state
Get-ADUser -Filter {Name -like "*admin*"} -Properties Name, UserPrincipalname, PasswordLastSet,LastLogonDate, Enabled | Select Name, UserPrincipalname, LastLogonDate, Enabled | Where-Object {$_.Enabled -ne "True"}


# Get Domain Admins LastLogon...
$da = @(Get-ADGroupMember "Domain admins"); foreach ($i in $da){Get-ADUser $i -Properties Name, UserPrincipalname, PasswordLastSet,LastLogonDate | Select Name, UserPrincipalname,PasswordLastSet, LastLogonDate}


# Who can change their own passwords (Abusable)
Get-ADUser -Filter * -Properties CannotChangePassword, UserPrincipalname, PasswordLastSet, LastLogonDate | Where-Object {$_.CannotChangePassword -eq "True"} | select Name, UserPrincipalname,PasswordLastSet, LastLogonDate


# Users with password never expires 
Get-ADUser -Filter * -Properties PasswordNeverExpires, UserPrincipalname, PasswordLastSet, LastLogonDate | Where-Object {$_.PasswordNeverExpires -eq "True"} | select Name, UserPrincipalname,PasswordLastSet, LastLogonDate


# Users with PasswordNotRequired attribute
Get-ADUser -Filter * -Properties PasswordNotRequired, UserPrincipalname, PasswordLastSet, LastLogonDate | Where-Object {$_.PasswordNotRequired -eq "True"} | select Name, UserPrincipalname,PasswordLastSet, LastLogonDate


# Find ManagedGroups and Users (Abusable)
$mg = @(Get-ADGroup -Filter * -Properties ManagedBy | Where-Object {$_.ManagedBy -ne $null} | select Name, ManagedBy)
$mgu = @()
$mg

foreach ($u in ($mg.ManagedBy | select -Unique)){

$mgu += (Get-ADUser -Filter * -Properties DistinguishedName | Where-Object {$_.DistinguishedName -eq $u}).Name

}



# Find Interesting DACLs (Abusable)

$dom = (Get-ADDomain -Current LoggedOnUser).DistinguishedName
$da = (Get-ADGroup "Domain admins").DistinguishedName
$du = (Get-ADGroup "Domain users").DistinguishedName

Set-Location ad:

#Top Level
(Get-Acl $dom).Access | select IdentityReference, AccessControlType, ActiveDirectoryRights

#Domain Admin
(Get-Acl $da).Access | select IdentityReference, AccessControlType, ActiveDirectoryRights

#Domain Users
(Get-Acl $du).Access | select IdentityReference, AccessControlType, ActiveDirectoryRights

Set-Location C:\




