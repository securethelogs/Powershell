 Write-Output ""
    $toencode = Read-Host -Prompt "Enter The Value To Encode"
    $base64 = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes(“$toencode”))

    Write-Output ""
    Write-Output "Encoded Command Below:"
    Write-Output ""
    $base64
    Write-Output ""