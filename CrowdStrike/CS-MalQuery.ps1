<# API Guide: https://falcon.crowdstrike.com/documentation/46/crowdstrike-oauth2-based-apis #>

$results = @()
$noauth = 0
$clientid = "Make sure you enter"
$csecret = "Make sure you enter"

$logo = @('

 ██████╗███████╗      ███╗   ███╗ █████╗ ██╗      ██████╗ ██╗   ██╗███████╗██████╗ ██╗   ██╗    
██╔════╝██╔════╝      ████╗ ████║██╔══██╗██║     ██╔═══██╗██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝    
██║     ███████╗█████╗██╔████╔██║███████║██║     ██║   ██║██║   ██║█████╗  ██████╔╝ ╚████╔╝     
██║     ╚════██║╚════╝██║╚██╔╝██║██╔══██║██║     ██║▄▄ ██║██║   ██║██╔══╝  ██╔══██╗  ╚██╔╝      
╚██████╗███████║      ██║ ╚═╝ ██║██║  ██║███████╗╚██████╔╝╚██████╔╝███████╗██║  ██║   ██║       
 ╚═════╝╚══════╝      ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝       
                                                                                            
@Securethelogs ; Lookup SHA256 hashes using the Crowdstrike MalQuery API
'); $logo


# -- Get Client Details --

 $param = @{
    URI = 'https://api.crowdstrike.com/oauth2/token'
    Method = 'post'
    Headers = @{

        accept = 'application/json'
        'content-type' = 'application/x-www-form-urlencoded'
    
    }
    Body = "client_id=$clientid&client_secret=$csecret"


}

# -- Request Token --

$token = try { (Invoke-RestMethod @param).Access_Token; } catch { Write-Host "[!] Status: Failed to issue access token" -ForegroundColor Red ; $noauth = 1 }

if ($noauth -eq 0){

Write-Host "Status: Access Granted" -ForegroundColor Green

# -- Get File of Hashes and Test --

Write-Output ""

$file = Read-Host -Prompt "Please Enter File Location"

Write-Output ""

if ($file.EndsWith(".txt") -and (Test-Path $file) -eq $true){

$hashbrowns = @(Get-Content $file)

# -- Foreach Hash; Test --

foreach ($hb in $hashbrowns){

$errc = 0


    $paramhash = @{
        URI = "https://api.crowdstrike.com/malquery/entities/metadata/v1?ids=$hb"
        Method = 'GET'
        Headers = @{
    
                Accept = 'application/json'
                Authorization = "Bearer $token"
    
                }


    } # Params 

$res = try { Invoke-RestMethod @paramhash } catch { $errc = 1; Write-Host "Error: Hash $hb may be incorrect or not supported" -ForegroundColor Red }


    if ($errc -ne 1){

        if ($res.resources -eq $null){ Write-Host "Hash: $hb was not found" -ForegroundColor Yellow } else { $results += $res.resources }

    } # No Error

 } # Hashbrowns


 if ($results -ne $null){ $results | Format-Table first_seen,label,family,filetype,sha256,sha1,md5 }

# -- File Validation --

} else { Write-Host "The file was not found. Please check the entered path: $file" -ForegroundColor Red }

} # Auth check
