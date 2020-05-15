$dom = (Get-WmiObject Win32_ComputerSystem).Domain

$fnd = @(Get-Childitem -Path \\$dom\sysvol\$dom\Policies -Recurse -force -ErrorAction SilentlyContinue -Include *.xml*)

foreach ($d in $fnd.Fullname){

$cp = Get-Content -Path $d | Select-String -Pattern "cpassword"

if ($cp -ne $null){

Write-Output "Found in: $d"

}

}
