#Connect To Sharepoint Online

#Name of your tenant for example Contoso

$name = Read-Host -Prompt "Name of Company"
Connect-SPOService -Url "https://$name-admin.sharepoint.com" -Credential ""


#Run policy check
$testconnection = get-SPOTenant

#If blank, failed
if ($testconnection -eq $NULL) {

Write-Output "Connection failed....."

} else {

#If values are returned, show connected...
Write-Output "`n"
Write-Output "Connected to $name-admin.sharepoint.com......."
Write-Output "To check policies, run 'get-SPOTenant'"
Write-Output "`n"

}