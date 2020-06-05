
$i = (curl "http://ifconfig.me/ip" -UseBasicParsing).Content
$ps = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
$w = 80

Write-Output "Scanning $i ..."
Write-Output ""

foreach ($p in $ps){

    $t = new-Object system.Net.Sockets.TcpClient

    $r = $t.ConnectAsync($i,$p).Wait($w)

    if ($r -eq "True") {
      
      Write-Output "Port $p is open"

     }

    }
