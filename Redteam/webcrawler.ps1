

Write-Output ""
Write-Output "Please enter a URL to crawl / example: https://securethelogs.com"
Write-Output ""


$url = Read-Host -Prompt "URL"
if ($url.EndsWith("/") -eq $false){$url = $url + "/"}
if ($url.StartsWith("http") -eq $false){$url = "http://" + $url}

$wordlist = @(Get-Content -Path (Read-Host -Prompt "Location of Wordlist"))
$sf = Read-Host -Prompt "Show fails? Y/N"

Write-Output ""

foreach ($i in $wordlist){

$crawlurl = $url + $i
$f = $false

try{$crawl = Invoke-WebRequest $crawlurl -UseBasicParsing}catch{
$f = $true
if ($sf -eq "y"){Write-Output "$crawlurl : failed"}else{}}


if ($crawl.statuscode -ne $null -and $f -eq $false){

$code = $crawl.statuscode

Write-Output "$crawlurl   :   Code: $code"

} 

}

