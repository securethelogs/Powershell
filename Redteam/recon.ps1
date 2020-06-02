       
$user = whoami
$currenthost = hostname 
$networkinfo = (Get-NetIPAddress).IPAddress


Write-Output ""
Write-Output "User: $user"
Write-Output "Hostname: $currenthost"
Write-Output ""
Write-Output "Network IP/s:"
$networkinfo
Write-Output ""
Write-Output "Getting details on $user......"

whoami /all


Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "LOCAL ADMIN INFORMATION"
Write-Output "-----------------------"
Write-Output ""

net localgroup Administrators


Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "LOCAL USERS INFORMATION"
Write-Output "-----------------------"
Write-Output ""

net users

Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "CURRENT LOGGED IN USERS"
Write-Output "-----------------------"
Write-Output ""


query user /server:$SERVER


Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "PROGRAM INFORMATION"
Write-Output "-------------------"
Write-Output ""

$progs = (dir "c:\program files").Name
$progs32 = (dir "c:\Program Files (x86)").Name
$allprogs = @($progs,$progs32)

$allprogs

Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "SMBSHARE INFORMATION"
Write-Output "-------------------"
Write-Output ""

 Get-SmbShare


Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "INTERNET ACCESS TEST"
Write-Output "-------------------"
Write-Output ""


$Publicip = (curl http://ipinfo.io/ip -UseBasicParsing).content
$internetcheckgoogle = (Test-NetConnection google.com -Port 443).TcpTestSucceeded
$internetcheckseclogs = (Test-NetConnection securethelogs.com -Port 443).TcpTestSucceeded
$internetcheckMicro = (Test-NetConnection Microsoft.com -Port 443).TcpTestSucceeded

Write-Output "Public IP: $Publicip"
Write-Output ""
Write-Output "Can I Reach Google: $internetcheckgoogle"
Write-Output "Can I Reach Securethelogs: $internetcheckseclogs"
Write-Output "Can I Reach Microsoft: $internetcheckMicro"


Write-Output ""
Write-Output "-------------------------------"
Write-Output ""
Write-Output "FIREWALL INFORMATION (Blocks)"
Write-Output "-------------------"
Write-Output ""

Get-NetFirewallRule | Where-Object Action -eq "Block" | Format-Table DisplayName,Enabled,Profile,Direction,Action,Name

Write-Output ""
    

