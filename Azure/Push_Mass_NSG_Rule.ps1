# Script to deploy mass rules to all NSGs (Within a subscription) 

$mnsg = @('


███╗   ███╗ █████╗ ███████╗███████╗    ███╗   ██╗███████╗ ██████╗ 
████╗ ████║██╔══██╗██╔════╝██╔════╝    ████╗  ██║██╔════╝██╔════╝ 
██╔████╔██║███████║███████╗███████╗    ██╔██╗ ██║███████╗██║  ███╗
██║╚██╔╝██║██╔══██║╚════██║╚════██║    ██║╚██╗██║╚════██║██║   ██║
██║ ╚═╝ ██║██║  ██║███████║███████║    ██║ ╚████║███████║╚██████╔╝
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ 

Creator: Securethelogs.com / @securethelogs


')

$mnsg

 try { Get-AzContext -ListAvailable } catch {  Connect-AzAccount }

 Write-Output ""
 
 $sub = Read-Host -Prompt "Please Enter A SubscriptionName"

 try { Set-AzContext -SubscriptionName $sub } catch { Write-Host "Error, closing script...."; end }

 $nsgs = @((Get-AzNetworkSecurityGroup).Name)


 Write-Host "When using Any or All within the rule, enter * when prompted" -ForegroundColor Green
 
 $happy = $null

 While ($happy -ne "Y"){

 Write-Output ""
 
 $name = Read-Host -Prompt "Rule Name"
 $description = Read-Host -Prompt "Description"
 $access = Read-Host -Prompt "Allow or Deny"
 $protocol = Read-Host -Prompt "TCP / UDP / ICMP"
 $direction = Read-Host -Prompt "Inbound or Outbound"
 $priority = Read-Host -Prompt "Priority Number"
 $sourceaddressprefix = Read-Host -Prompt "Source Address Prefix"
 $sourceportrange = Read-Host -Prompt "Source Port (Range or Single)"
 $destinationaddressprefix = Read-Host -Prompt "Destination Address Prefix"
 $destinationportrange = Read-Host -Prompt "Destination Port (Range or Single)"

 
 Write-Output ""

 Write-Host "Please validate the below rule ..." -ForegroundColor Red
 
 Write-Output ""

 Write-Host "Name: " -NoNewline; $name
 Write-Host "Description: " -NoNewline; $description
 Write-Host "Access: " -NoNewline; $access
 Write-Host "Protocol : " -NoNewline; $protocol
 Write-Host "Direction: " -NoNewline; $direction
 Write-Host "Priority: " -NoNewline; $priority
 Write-Host "SourceAddressPrefix: " -NoNewline; $sourceaddressprefix
 Write-Host "SourcePortRange: " -NoNewline; $sourceportrange
 Write-Host "DestinationAddressPrefix: " -NoNewline; $destinationaddressprefix
 Write-Host "DestinationPortRange: " -NoNewline; $destinationportrange
 
 Write-Output ""

 $happy = Read-Host -Prompt "Happy with the above ? (Y/N)"

 Write-Output ""
 
 }

 foreach ($nsg in $nsgs) {
 
$nsg = Get-AzNetworkSecurityGroup -Name $nsg


$nsg | Add-AzNetworkSecurityRuleConfig -Name $name -Description $description -Access $access `
    -Protocol $protocol -Direction $direction -Priority $priority -SourceAddressPrefix $sourceaddressprefix -SourcePortRange $sourceportrange `
    -DestinationAddressPrefix $destinationaddressprefix -DestinationPortRange $destinationportrange -ErrorAction SilentlyContinue


$nsg | Set-AzNetworkSecurityGroup

 }

Write-Output ""

Write-Host "Validating rules...."

Write-Output ""

foreach ($nsg in $nsgs) {


$validate = Get-AzNetworkSecurityGroup -Name $nsg | Get-AzNetworkSecurityRuleConfig -Name $name -ErrorAction SilentlyContinue

    if ($validate -ne $null){
    
    Write-Host "Network Security Group: $nsg  - " -NoNewline ; Write-Host " Passed" -ForegroundColor Green
    
    } else {
    
    Write-Host "Network Security Group: $nsg  - " -NoNewline ; Write-Host " Failed" -ForegroundColor Red
    
    } 


}