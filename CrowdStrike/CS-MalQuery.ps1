<# API Guide: https://falcon.crowdstrike.com/documentation/46/crowdstrike-oauth2-based-apis
   Access rights: Read - Indicators and Actors
   Hybrid-Analysis API is optional.
 #>

# -- Global --
$results = @()
$hbresults = @()
$noauth = 0
$nofalcon = @()
$family = @()


# -- Falcon MalQuery (Required) --
$clientid = ""
$csecret = ""

# -- Hybrid-Analysis (Optional) --

$haapikey = ""


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

$res = try { Invoke-RestMethod @paramhash } catch { $errc = 1; Write-Host "Error: Hash $hb may be incorrect or not supported" -ForegroundColor Red ; $nofalcon += $hb }


    if ($errc -ne 1){

        if ($res.resources -eq $null){ Write-Host "Hash: $hb was not found" -ForegroundColor Yellow; $nofalcon += $hb } else { $results += $res.resources
        if ($res.resources.family){$family += ($res.resources.family)} }

    } # No Error

 } # Hashbrowns


 if ($results -ne $null){ 
 
 $results | Format-Table first_seen,label,family,filetype,sha256,sha1,md5 

 Write-Output " ------  "
 Write-Output ""
 
 }

 if ($family -ne $null){

 Write-Host "Status: Malware Family found!" -ForegroundColor Green
 
    foreach ($fam in $family){

    Write-Output ""
    Write-Host "[*] Searching for family: $fam"
    Write-Output ""

    $uri = ("https://api.crowdstrike.com/intel/queries/actors/v1?filter=kill_chain.installation%3A'" + $fam + "'").ToLower()

    $param = @{
        URI = $uri
        Method = 'GET'
        Headers = @{
                Authorization = "Bearer $token"  
                "Content-Type" = "application/json" 
                }

    } # Params 

try { 

$r = Invoke-RestMethod @param
$actids = @($r.resources)

 } catch { Write-Host "Error: Something went wrong when querying actors ! " -ForegroundColor Red} 


if ($actids){

foreach ($aid in $actids){

    $param = @{
        URI = "https://api.crowdstrike.com/intel/entities/actors/v1?ids=$aid"
        Method = 'GET'
        Headers = @{
                Authorization = "Bearer $token"  
                "Content-Type" = "application/json" 
                }

    } # Params 

try{ $r = Invoke-RestMethod @param } catch { Write-Host "Error: Something went wrong when querying actors ! " -ForegroundColor Red} 

## start output

Write-Output ""
Write-Host "ID: " -NoNewline; Write-Host ($r.Resources.id)
Write-Host "Name: " -NoNewline; Write-Host ($r.Resources.name) -ForegroundColor Yellow
Write-Host "KnownAs: "-NoNewline; Write-Host ($r.resources.known_as) -ForegroundColor Yellow
if (($r.Resources.active) -eq $false){ Write-Host "Active: " -NoNewline; Write-Host ($r.Resources.active) -ForegroundColor Red } else { Write-Host "Active: " -NoNewline; Write-Host ($r.Resources.active) -ForegroundColor Green }
Write-Host "Region: " -NoNewline; Write-Host ($r.Resources.region.value)
Write-Host "URL: "($r.resources.url)

Write-Output ""
Write-Host "Desc: "($r.Resources.short_description)

## End output

Write-Output ""
Write-Output "  --------    "
Write-Output ""


} 


} else { 

    Write-Host "Family: $fam has not results ..." -ForegroundColor Yellow 
    Write-Output ""
    Write-Output "  --------    "
    Write-Output ""

} #foreach actor

 
    
    }
 
 }


    if ($haapikey -ne ""){

    Write-Output ""


    $who = @{
        URI = "https://www.hybrid-analysis.com/api/v2/key/current"
        Method = 'GET'
        Headers = @{
        'accept' = 'application/json'
        'user-agent' = 'Falcon Sandbox'
        'api-key' = "$haapikey"   
        }

    }

    try {$who = Invoke-RestMethod @who}catch{ Write-Host "[!} Failed to Auth...." -ForegroundColor Red}

    Write-Host "Hybrid-Analysis Key Detected" -ForegroundColor Green -NoNewline

    if ($who -ne $null){Write-Host ("    |   User: " + $who.user.email)}
    
    Write-Output ""


    foreach ($hb in $hashbrowns){

    $hash = "hash=" + $hb
    
       $hbparam = @{
        URI = "https://www.hybrid-analysis.com/api/v2/search/hash"
        Method = 'POST'
        Headers = @{
        'accept' = 'application/json'
        'user-agent' = 'Falcon Sandbox'
        'Content-Type' = 'application/x-www-form-urlencoded'
        'api-key' = "$haapikey"   
        }
            Body =  $hash

    }

    
    try {$res = Invoke-RestMethod @hbparam} catch {Write-Host "Error: Hash $hb may be incorrect or not supported" -ForegroundColor Red}
    
    if ($res.sha256 -eq $null){Write-Host "Hash: $hb was not found" -ForegroundColor Yellow} else {
        
        $res | Add-Member -Type NoteProperty -Name 'VirusTotal' -Value ("https://www.virustotal.com/gui/file/" + $hb)
    
        $hbresults += $res
    
    
        }  

 
    }

    if ($hbresults -ne $null){
    
    
    
    $hbresults | Format-Table Sha256, verdict, threat_score, av_detect, vx_family, environment_description, VirusTotal


    }
 
 
 } else { 

       Write-Output ""
       Write-Host "[!] No Hybrid-Analysis API Found.... skipping " -ForegroundColor Red 
       Write-Output ""

        }

# -- File Validation --

} else { Write-Host "The file was not found. Please check the entered path: $file" -ForegroundColor Red }

} # Auth check
