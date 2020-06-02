
Write-Output ""
Write-Output "Option 1: Query Dlls"
Write-Output "Option 2: Show missing DLLs I can touch"
Write-Output ""

$opt = Read-Host -Prompt "Option"


if ($opt -ne "1" -and $opt -ne "2"){exit}

If ($opt -eq "1"){

Write-Output ""

$q = Read-Host -Prompt "Search keyword (Use * to list all):"

$a = @(Get-Process -IncludeUserName | Where-Object {$_.ProcessName -like "*$q*"} | Select-Object *)

$C = @()

foreach ($l in $a){

$b = @($l.Modules.FileName)


foreach ($m in $b){

$l | Select-Object name,path,username, {$m}

}


}




}

If ($opt -eq "2"){

$a = @(Get-Process -IncludeUserName | Select-Object *)


$C = @()

foreach ($l in $a){

$b = @($l.Modules.FileName)



foreach ($m in $b){

if ($m -ne $null){

if ((Test-Path $m) -eq $false){


$cp = (Get-Acl ($m -replace ($l.Modules | Where-Object {$_.FileName -eq $m}).ModuleName,"") -ErrorAction SilentlyContinue).Access.IdentityReference | Where-Object {$_ -match ($env:username)}

if ($cp -ne $null){


$c += $l | Select-Object name,path,username, {$m}, "true"

} #cp null


} # Test-path


} # Null check



} # Foreach m in b


}

$C | Format-Table



}



