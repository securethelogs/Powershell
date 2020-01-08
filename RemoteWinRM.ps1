#If remote session avaible do X

Write-Output "`n"
$comp = Read-Host -Prompt "Enter The Computer Name or IP"
$testcont = test-netconnection -ComputerName "$comp" -CommonTCPPort WINRM -InformationLevel Quiet



if ($testcont -eq "True"){

#If successful, write message
Write-Output "`n"
Write-Output "Services Appears To Be Running...."
Write-Output "Attempting To Connect To $comp.............."
Write-Output "`n"

Enter-PSSession -ComputerName $comp


} 

#If failed, write message

elseif ($results -eq "False" -or $results -contains "failed") {
Write-Output "`n"
Write-Output "Failed To Connect To $comp"


}