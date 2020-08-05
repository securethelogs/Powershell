<# 

This script is for enabling all storage accounts within a resource group to be managed via Azure Key Vaults...

Author: securethelogs.com  / @securethelogs



#>



Write-Output ""

Write-Host " [*] This Script Will Allow You To Manage Storage Keys Via Azure Key Vault ..."
Write-Host " [*] Checking If Connected ..."


try {

$tst = Get-AzTenant -ErrorAction SilentlyContinue

} catch {
        
        Write-Host "Not connected to AZModule. Attempting To Run Connect-AzAccount" -ForegroundColor Red
        Connect-AzAccount

        }


Write-Host " [*] Connected to Az Module ..." -ForegroundColor Green




# Get RSG and Vault

Get-AzResourceGroup | Format-Table ResourceGroupName, Location, Tags, ResourceId 
$resourceGroupName = Read-Host -Prompt " ResourceGroupName"

Get-AzKeyVault -ResourceGroupName $resourceGroupName | Format-Table VaultName, ResourceGroupName, Location, Tags
$keyVaultName = Read-Host -Prompt " KeyVaultName"

$sas = @(Get-AzStorageAccount -ResourceGroupName $resourceGroupName)

$keyVaultSpAppId = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
$Keys = @("key1", "key2")
$userId = (Get-AzContext).Account.Id


Write-Output ""


Write-Host " [*] Script Will Run Against The Following StorageAccounts ... "

$sas

Write-Output ""





foreach ($sa in $sas){


# Get a reference to your Azure storage account
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -StorageAccountName $sa.StorageAccountName

# Assign RBAC role "Storage Account Key Operator Service Role" to Key Vault, limiting the access scope to your storage account. For a classic storage account, use "Classic Storage Account Key Operator Service Role." 
New-AzRoleAssignment -ApplicationId $keyVaultSpAppId -RoleDefinitionName 'Storage Account Key Operator Service Role' -Scope $storageAccount.Id -ErrorAction SilentlyContinue

# Give your user principal access to all storage account permissions, on your Key Vault instance
Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -UserPrincipalName $userId -PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, setsas, recover, backup, restore, purge


    foreach ($key in $keys){
    

        # Add your storage account to your Key Vault's managed storage accounts
        Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $sa.StorageAccountName -AccountResourceId $sa.Id -ActiveKeyName $key -DisableAutoRegenerateKey


        $regenPeriod = [System.Timespan]::FromDays(3)
        Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $sa.StorageAccountName -AccountResourceId $sa.Id -ActiveKeyName $key -RegenerationPeriod $regenPeriod


      
    }



}

Write-Output ""


Write-Host " [*] Checking On Managed Accounts ... "
Write-Host " [*] Storage Accounts Listed In Green Are Already Managed By Key Vault" -ForegroundColor Green


    
Write-Output ""

$managed = @()
$vaults = @(Get-AzKeyVault)

    foreach ($v in $vaults){

    $chkv = Get-AzKeyVaultManagedStorageAccount -VaultName $v.VaultName -ErrorAction SilentlyContinue

        if ($chkv -ne $null){
        
                        $managed += $chkv.AccountName
        
                        }

    }


    

$sa = @((Get-AzStorageAccount -ResourceGroupName $resourceGroupName).StorageAccountName)

    foreach ($s in $sa){



    
        if ($managed.contains($s) -eq "True"){ 

        

            Write-Host " StorageAccountName: $s" -ForegroundColor Green
        
        
            } else {
            
                write-host " StorageAccountName: $s" -ForegroundColor White
            
                }
                 
    
        }

Write-Output ""