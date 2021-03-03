Write-Output ""
Write-Host "Microsoft Details Here: https://www.microsoft.com/security/blog/2021/03/02/hafnium-targeting-exchange-servers/"

Write-Output ""

Write-Host "Running Microsoft Check 1" -foregroundcolor "Yellow"

findstr /snip /c:"Download failed and temporary file" "%PROGRAMFILES%\Microsoft\Exchange Server\V15\Logging\OABGeneratorLog\*.log"

Write-Output ""

Write-Host "Running Microsoft Check 2" -foregroundcolor "Yellow"

Get-EventLog -LogName Application -Source "MSExchange Unified Messaging" -EntryType Error | Where-Object { $_.Message -like "*System.InvalidCastException*" }

Write-Output ""

Write-Host "Running Microsoft Check 3" -foregroundcolor "Yellow"

Select-String -Path "$env:PROGRAMFILES\Microsoft\Exchange Server\V15\Logging\ECP\Server\*.log" -ErrorAction SilentlyContinue  -Pattern 'Set-.+VirtualDirectory'

Write-Output ""


write-host "Checking for ASPX Files.." -foregroundcolor "Yellow"
Write-Output ""

write-host "Searching in: C:\inetpub\wwwroot\aspnet_client\"

get-childitem -include "*.aspx" -recurse "C:\inetpub\wwwroot\aspnet_client\" -ErrorAction SilentlyContinue  | Select-Object LastWriteTime, Name

Write-Output ""
write-host "Searching in: C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\"

get-childitem -include "*.aspx" -recurse "C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\" -ErrorAction SilentlyContinue  | Select-Object LastWriteTime, Name

Write-Output ""
write-host "Searching in: C:\Exchange\FrontEnd\HttpProxy\owa\auth\"
Write-Output ""
start-sleep -seconds 1

get-childitem -include "*.aspx" -recurse "C:\Exchange\FrontEnd\HttpProxy\owa\auth\" -ErrorAction SilentlyContinue  | Select-Object LastWriteTime, Name

start-sleep -seconds 1
Write-Output ""

write-host "Checking for Zips within ProgramData (General Check)"

Write-Output ""

(get-childitem -include "*.zip" -recurse "C:\ProgramData\" -ErrorAction SilentlyContinue).FullName
(get-childitem -include "*.rar" -recurse "C:\ProgramData\" -ErrorAction SilentlyContinue).FullName
(get-childitem -include "*.7z" -recurse "C:\ProgramData\" -ErrorAction SilentlyContinue).FullName

