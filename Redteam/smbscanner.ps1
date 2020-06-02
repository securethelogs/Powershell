

Write-Output ""
Write-Output "For Mass Scans, Enter the File Path (C:\temp\iplist.txt)"
Write-Output ""

$smbdst = read-host -Prompt "Destination"

if ($smbdst -like "*.txt"){

$listsmb = @(Get-Content $smbdst)

foreach ($i in $listsmb){

Write-Output ""
Write-Output "Scanning $i"
Write-Output ""

try{net view \\$i\ /all | Select-Object -Skip 6}catch{Write-Output "SMB Probe Failed or Unreachable"}



}


}

net view \\$smbdst\ /all | Select-Object -Skip 6



