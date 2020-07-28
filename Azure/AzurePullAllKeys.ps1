
<#

Creator: Securethelogs.com  / @securethelogs

#>

Write-Host "This script to show the value of RBAC and the need to limit access to keys. " -ForegroundColor Red

Write-Output ""

Write-Host " [*] Microsoft Default Connection URLs are ..."

Write-Output ""

Write-Host " Blob storage: http://" -NoNewline ; Write-Host "mystorageaccount" -NoNewline -ForegroundColor Red; Write-Host ".blob.core.windows.net"
Write-Host " File storage: http://" -NoNewline ; Write-Host "mystorageaccount" -NoNewline -ForegroundColor Red; Write-Host ".file.core.windows.net"
Write-Host " Table storage: http://" -NoNewline ; Write-Host "mystorageaccount" -NoNewline -ForegroundColor Red; Write-Host ".Table.core.windows.net"
Write-Host " Queue storage: http://" -NoNewline ; Write-Host "mystorageaccount" -NoNewline -ForegroundColor Red; Write-Host ".queue.core.windows.net"

$sas = @(Get-AzStorageAccount)



Write-Output ""

Write-Host " [*] Starting Search ..."

Write-Output ""

foreach ($sa in $sas){

Write-Host " StorageAccountName: " -NoNewline;  Write-Host $sa.StorageAccountName -ForegroundColor Green
Write-Host " ResourceGroupName: " -NoNewline;  Write-Host $sa.ResourceGroupName -ForegroundColor Green

Get-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -StorageAccountName $sa.StorageAccountName | Format-Table -HideTableHeaders

Write-Output ""

}

