       
    Write-Output ""


    Write-Output "Enter Either A Single IP or IP List (C:\Temp\example.txt)"
    
    
    [string]$gettargets = Read-Host -Prompt "."


  
    # -------------- If IP List ------------------

    if ($gettargets -like "*txt") {
    
    $PulledIPs = Get-Content $gettargets


    Write-Output ""
    Write-Output "Resolving...."

    
    foreach ($i in $PulledIPs) {

    # Test if can resolve
        
    $firsttest = Resolve-DnsName $i -erroraction SilentlyContinue

    # If not, show fail...

    if ($firsttest -eq $null){
    
    Write-Output ""

    Write-Output "IP: $i      |       DNS: Failed To Resolve"
    
    
    }

    #If can, show result...

    else {

    $resolve = (Resolve-DnsName $i).NameHost

    
    Write-Output ""

    Write-Output "IP: $i      |       DNS: $resolve"
   

    }
    
    } # for each

    Write-Output ""


    } # If txt
    
    # --------------- Attempt Single Scan ---------------

    else {

    $i = $gettargets
    
    # Test if can resolve

        
    $firsttest = Resolve-DnsName $i -erroraction SilentlyContinue

    # If not, show fail...

    if ($firsttest -eq $null){
    
    Write-Output ""

    Write-Output "IP: $i      |       DNS: Failed To Resolve"
    Write-Output ""
    
    }

    #If can, show result...

    else {

    $resolve = (Resolve-DnsName $i).NameHost

    
    Write-Output ""

    Write-Output "IP: $i      |       DNS: $resolve"
    Write-Output ""

    }

    }
    

