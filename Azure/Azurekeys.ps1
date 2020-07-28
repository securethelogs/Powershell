<#

This script is to help enable management of StorageAccountKeys within Azure Key Vault

#>

$logo = @('

   ▄▄▄      ▒███████▒ █    ██  ██▀███  ▓█████  ██ ▄█▀▓█████▓██   ██▓  ██████ 
 ▒████▄    ▒ ▒ ▒ ▄▀░ ██  ▓██▒▓██ ▒ ██▒▓█   ▀  ██▄█▒ ▓█   ▀ ▒██  ██▒▒██    ▒ 
 ▒██  ▀█▄  ░ ▒ ▄▀▒░ ▓██  ▒██░▓██ ░▄█ ▒▒███   ▓███▄░ ▒███    ▒██ ██░░ ▓██▄   
 ░██▄▄▄▄██   ▄▀▒   ░▓▓█  ░██░▒██▀▀█▄  ▒▓█  ▄ ▓██ █▄ ▒▓█  ▄  ░ ▐██▓░  ▒   ██▒
  ▓█   ▓██▒▒███████▒▒▒█████▓ ░██▓ ▒██▒░▒████▒▒██▒ █▄░▒████▒ ░ ██▒▓░▒██████▒▒
  ▒▒   ▓▒█░░▒▒ ▓░▒░▒░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░░ ▒░ ░▒ ▒▒ ▓▒░░ ▒░ ░  ██▒▒▒ ▒ ▒▓▒ ▒ ░
   ▒   ▒▒ ░░░▒ ▒ ░ ▒░░▒░ ░ ░   ░▒ ░ ▒░ ░ ░  ░░ ░▒ ▒░ ░ ░  ░▓██ ░▒░ ░ ░▒  ░ ░
   ░   ▒   ░ ░ ░ ░ ░ ░░░ ░ ░   ░░   ░    ░   ░ ░░ ░    ░   ▒ ▒ ░░  ░  ░  ░  
       ░  ░  ░ ░       ░        ░        ░  ░░  ░      ░  ░░ ░           ░  
           ░                                               ░ ░              
 
 Creator: Securethelogs.com   / @Securethelogs


')


$logo


try {

$tst = Get-AzTenant -ErrorAction SilentlyContinue

} catch {
        
        Write-Host "Not connected to AZModule. Attempting To Run Connect-AzAccount" -ForegroundColor Red
        Connect-AzAccount

        }


Write-Output ""

Write-Host " [*] This Script Will Allow You To Manage Storage Keys Via Azure Key Vault ..."
Write-Host " [*] Listing ResourceGroups ..." -NoNewline ; Write-Host "If You Don't See Your Resources, Set The AZ Context (Set-AzContext)" -ForegroundColor Red


Write-Output ""

$managed = @()
$vaults = @(Get-AzKeyVault)

    foreach ($v in $vaults){

    $chkv = Get-AzKeyVaultManagedStorageAccount -VaultName $v.VaultName -ErrorAction SilentlyContinue

        if ($chkv -ne $null){
        
                        $managed += $chkv.AccountName
        
                        }

    }



Get-AzResourceGroup | Format-Table ResourceGroupName, Location, Tags, ResourceId
$resourceGroupName = Read-Host -Prompt " ResourceGroupName:"


$sa = @((Get-AzStorageAccount -ResourceGroupName $resourceGroupName).StorageAccountName)

    foreach ($s in $sa){


    Write-Host " [*] Storage Accounts Listed In Green Are Already Managed By Key Vault"
    Write-Output ""

    
        if ($managed.contains($s) -eq "True"){ 

        

            Write-Host " StorageAccountName: $s" -ForegroundColor Green
        
        
            } else {
            
                write-host " StorageAccountName: $s" -ForegroundColor White
            
                }
                 
    
        }


Write-Output ""

$storageAccountName = Read-Host -Prompt " StorageAccountName" 

Write-Output ""

Write-Host " [*] Getting Azure Key Vaults ..."

Get-AzKeyVault -ResourceGroupName $resourceGroupName | Format-Table VaultName, ResourceGroupName, Location, Tags
$keyVaultName = Read-Host -Prompt " KeyVaultName"


$keyVaultSpAppId = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

Write-Output ""

Write-Host " [*] Select A Key To Be Managed. Note: The Keys Shown Below Are Masked ..." -ForegroundColor Red

Write-Output ""

$keys = @(Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName)

    foreach ($key in $keys){
    
    Write-Host $key.KeyName -NoNewline ; Write-Host "  " -NoNewline ;  Write-Host ($key.Value).Substring(0,30) -NoNewline ; Write-Host "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    
    }

Write-Output ""

$knum = Read-Host -Prompt " Key Number"

$storageAccountKey = "key" + $knum


$userId = (Get-AzContext).Account.Id
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName


Write-Output ""
Write-Host " [*] Creating RBAC Permissions ..."

# Assign RBAC role "Storage Account Key Operator Service Role" to Key Vault, limiting the access scope to your storage account. For a classic storage account, use "Classic Storage Account Key Operator Service Role." 
New-AzRoleAssignment -ApplicationId $keyVaultSpAppId -RoleDefinitionName 'Storage Account Key Operator Service Role' -Scope $storageAccount.Id

# Give your user principal access to all storage account permissions, on your Key Vault instance
Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -UserPrincipalName $userId -PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, setsas, recover, backup, restore, purge

# Add your storage account to your Key Vault's managed storage accounts
Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $storageAccountName -AccountResourceId $storageAccount.Id -ActiveKeyName $storageAccountKey -DisableAutoRegenerateKey

$rotnum = Read-Host -Prompt " How Many Days Before Rotation?"

$regenPeriod = [System.Timespan]::FromDays($rotnum)

Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $storageAccountName -AccountResourceId $storageAccount.Id -ActiveKeyName $storageAccountKey -RegenerationPeriod $regenPeriod

Write-Output ""

Write-Host " [*] If No Errors Are Present, The Key Is Now Managed" -ForegroundColor Green