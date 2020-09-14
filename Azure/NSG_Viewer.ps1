
$logo = @('

███╗   ██╗███████╗ ██████╗     ██╗   ██╗██╗███████╗██╗    ██╗███████╗██████╗ 
████╗  ██║██╔════╝██╔════╝     ██║   ██║██║██╔════╝██║    ██║██╔════╝██╔══██╗
██╔██╗ ██║███████╗██║  ███╗    ██║   ██║██║█████╗  ██║ █╗ ██║█████╗  ██████╔╝
██║╚██╗██║╚════██║██║   ██║    ╚██╗ ██╔╝██║██╔══╝  ██║███╗██║██╔══╝  ██╔══██╗
██║ ╚████║███████║╚██████╔╝     ╚████╔╝ ██║███████╗╚███╔███╔╝███████╗██║  ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝       ╚═══╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝
                                                                             

Creator: Securethelogs.com / @securethelogs


Options:

        1. View NSGs                   
        2. Search NSGs
        

')

$logo

$method = Read-Host "Option Number"



try { Get-AzContext -ListAvailable } catch {  Connect-AzAccount }

Write-Output ""

$sub = Read-Host -Prompt "Please Enter A SubscriptionName"

try { Set-AzContext -SubscriptionName $sub } catch { Write-Host "Error, closing script...."; end }




if ($method -eq "1"){

Write-Output ""
Write-Host "Listing NSGs Within $sub..."
Write-Output ""

$nsgs = @((Get-AzNetworkSecurityGroup).Name)

$count = 0


foreach ($nsg in $nsgs){


write-host $count -NoNewline ; Write-Host ".  " -NoNewline; Write-Host $nsg

$count++

}


Write-Host ""
Write-Host "Enter All to Show Every NSG Rule" -ForegroundColor Green 
Write-Host ""



$option = Read-Host -Prompt "Option Number"
Write-Host ""



    if ($option -lt $count){ 

    Write-Host $nsg -ForegroundColor Green
    
    Get-AzNetworkSecurityGroup -Name $nsgs[$option] | Get-AzNetworkSecurityRuleConfig | Format-Table Direction, name, SourceAddressPrefix, SourcePortRange, SourceApplicationSecurityGroups , DestinationAddressPrefix, DestinationPortRange, DestinationApplicationSecurityGroups, Access, Description | Sort-Object -Property Direction

    } else { 
        
            Write-Host "fail" 
            
            }



    if ($option -eq "all"){

        foreach ($nsg in $nsgs){

                                Write-Output ""
                                Write-Host $nsg -ForegroundColor Green
                                Get-AzNetworkSecurityGroup -Name $nsg| Get-AzNetworkSecurityRuleConfig | Format-Table Direction, name, SourceAddressPrefix, SourcePortRange, SourceApplicationSecurityGroups , DestinationAddressPrefix, DestinationPortRange, DestinationApplicationSecurityGroups, Access, Description | Sort-Object -Property Direction

                                }


      }


 }



 if ($method -eq "2"){
 
 Write-Output ""

 $term = Read-Host -Prompt "Please Enter A Keyword"
 Write-Output ""

 Write-Host "Searching Rules For $term ...."
 Write-Output ""


    foreach ($nsg in $nsgs){


                            $rules = @(Get-AzNetworkSecurityGroup -Name $nsg | Get-AzNetworkSecurityRuleConfig)

                                foreach ($r in $rules){


                                                        $rule = @($r.name, $r.Description, $r.DestinationAddressPrefix, $r.DestinationApplicationSecurityGroups, $r.SourceAddressPrefix, $r.SourceApplicationSecurityGroups)
                                                        $result = $rule | Select-String -Pattern $term -SimpleMatch -ErrorAction SilentlyContinue

                                                            if ($result -ne $null){
                                                                                    
                                                                                    Write-Host "Found In: " -NoNewline ; Write-Host $nsg -ForegroundColor Green

                                                                                    $r | Format-Table Direction, name, SourceAddressPrefix, SourcePortRange, SourceApplicationSecurityGroups , DestinationAddressPrefix, DestinationPortRange, DestinationApplicationSecurityGroups, Access, Description

                                                                                    Write-Output ""
                                                            
                                                                                    }

                                                        }

                                

                                

                                }

 
 
 }