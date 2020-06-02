
    $subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
    $manyips = $subnet.Length

    if($manyips -eq 2){$subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop[1]}
   
    
    
    $subnetrange = $subnet.Substring(0,$subnet.IndexOf('.') + 1 + $subnet.Substring($subnet.IndexOf('.') + 1).IndexOf('.') + 3)

    $isdot = $subnetrange.EndsWith('.')

    if ($isdot -like "False"){$subnetrange = $subnetrange + '.'}
    
$iprange = @(1..254)

Write-Output ""
Write-Output "Current Network: $subnet"
Write-Output ""
Write-Output "Scanning........"
Write-Output ""

foreach ($i in $iprange){


$currentip = $subnetrange + $i

$islive = test-connection $currentip -Quiet -Count 1

if ($islive -eq "True"){

try{$dnstest = (Resolve-DnsName $currentip -ErrorAction SilentlyContinue).NameHost}catch{}

if ($dnstest -like "*.home") {

$dnstest = $dnstest -replace ".home",""

}

Write-Output ""
Write-Output "Host is Reachable: $currentIP  |   DNS: $dnstest"


 # ------- Scanning host ---------

    $portstoscan = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
    $waittime = 100

    foreach ($p in $portstoscan){

    $TCPObject = new-Object system.Net.Sockets.TcpClient
    try{$result = $TCPObject.ConnectAsync($currentip,$p).Wait($waittime)}catch{}

    if ($result -eq "True"){
    
    Write-Output "Port Open: $p"
    
    }

    }

    







}

}

    