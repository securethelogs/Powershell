Connect-SPOService https://*YOUR_COMPANY_DOMAIN*-admin.sharepoint.com/

$sites = @(Get-SPOSite -Filter {Status -eq "Active"} -Limit ALL  | select-Object URL)

$Output = "C:\Temp\Sharepoint_Everyone.txt"

New-Item $Output


foreach ($s in $sites){

$site = $s.url
$c = 0

    Write-Output "Scanning $site ...."

    Try{ $usr = Get-SPOUser $site | Select-Object Displayname, LoginName -ErrorAction SilentlyContinue | Where-Object {$_.DisplayName -eq "Everyone"} } 
    
      catch{
                Write-Host "May not have permission" -ForegroundColor Green
                $c = 1
             }


    if ($usr -ne $null -and $c -ne 1){

        Write-Host "Everyone Found!!" -ForegroundColor Red

        Write-Output ""

        Add-Content -Path $Output -Value $site

    }

}


