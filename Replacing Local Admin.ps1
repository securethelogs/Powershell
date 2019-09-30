Write-Output "Please create a local admin account to use. Once you have completed this, your account will no longer have admin access"

$password = Read-Host -Prompt "Please Enter The Admin Password"
$user = whoami
$admin = "admin"
$localadmins = net localgroup administrators

#Convert password into securestring
$secpassword = ConvertTo-SecureString $password -AsPlainText -Force

#Create the admin account
New-LocalUser $admin -Password $secpassword -FullName "admin" -Description "local admin account"

#Add that user into the local admin group
Add-LocalGroupMember -Group "Administrators" -Member "admin"

#If the account has been successfully added, remvoe the users account

If ($localadmins -contains $admin)
{

#Remove the user from local admin group
Remove-LocalGroupMember -Group "Administrators" -Member $user

} 

else 

{

#Mention that the process may have failed.
Write-Output "No local admin account has been setup"

}
