
$basaspx = @('web.aspx',
'help.aspx',
'document.aspx',
'errorEE.aspx',
'errorEEE.aspx',
'errorEW.aspx',
'errorFF.aspx',
'healthcheck.aspx',
'aspnet_www.aspx',
'aspnet_client.aspx',
'xx.aspx',
'shell.aspx',
'aspnet_iisstart.aspx',
'one.aspx')


Write-Output ""

Write-Host "Microsoft Details Here: https://www.microsoft.com/security/blog/2021/03/02/hafnium-targeting-exchange-servers/"

Write-Output ""


Write-Host "Running Microsoft Check 1 (Blank = Good)" -foregroundcolor "Yellow"

findstr /snip /c:"Download failed and temporary file" "%PROGRAMFILES%\Microsoft\Exchange Server\V15\Logging\OABGeneratorLog\*.log"

Write-Output ""


Write-Host "Running Microsoft Check 2" -foregroundcolor "Yellow"

Get-EventLog -LogName Application -Source "MSExchange Unified Messaging" -EntryType Error | Where-Object { $_.Message -like "*System.InvalidCastException*" }

Write-Output ""


Write-Host "Running Microsoft Check 3" -foregroundcolor "Yellow"

Select-String -Path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\ECP\Server\*.log" -ErrorAction SilentlyContinue  -Pattern 'Set-.+VirtualDirectory'

Write-Output ""


Write-Host "Checking for ASPX Files.." -foregroundcolor "Yellow"
Write-Output ""


Write-Host "Searching in: C:\inetpub\wwwroot\aspnet_client\"

$asp = @(Get-ChildItem -include "*.aspx" -recurse "C:\inetpub\wwwroot\aspnet_client\" -ErrorAction SilentlyContinue).Name
Write-Output ""

if ($asp -eq $null){ Write-Host "No ASPX files found" -ForegroundColor "Green" } else {

        foreach ($bad in $basaspx){

            if ($asp -contains $bad){ Write-host "Suspicious file found: $bad" -ForegroundColor "Red" } else { Write-host "$bad not found" -ForegroundColor "Green" }

        }


    }

Write-Output ""
Write-Host "Searching in: C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\"

$asp = @(get-childitem -include "*.aspx" -recurse "C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\" -ErrorAction SilentlyContinue).Name

    foreach ($bad in $basaspx){

        if ($asp -contains $bad){ Write-host "Suspicious file found: $bad" -ForegroundColor "Red" } else { Write-host "$bad not found" -ForegroundColor "Green" }

    }


Write-Output ""
write-host "Searching in: C:\Exchange\FrontEnd\HttpProxy\owa\auth\"

Write-Output ""
Start-Sleep -seconds 1

$asp = @(get-childitem -include "*.aspx" -recurse "C:\Exchange\FrontEnd\HttpProxy\owa\auth\" -ErrorAction SilentlyContinue).Name

    foreach ($bad in $basaspx){

        if ($asp -contains $bad){ Write-host "Suspicious file found: $bad" -ForegroundColor "Red" } else { Write-host "$bad not found" -ForegroundColor "Green" }

    }


Start-Sleep -seconds 1
Write-Output ""

Write-Host "Checking for Zips within ProgramData (General Check). Anything highlighted does not indicate compromise"

Write-Output ""

(Get-ChildItem -include "*.zip" -recurse "C:\ProgramData\" -ErrorAction SilentlyContinue).FullName
(Get-ChildItem -include "*.rar" -recurse "C:\ProgramData\" -ErrorAction SilentlyContinue).FullName
(Get-ChildItem -include "*.7z" -recurse "C:\ProgramData\" -ErrorAction SilentlyContinue).FullName
