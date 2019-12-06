#Display Kerberos Token

$token = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$token