
$logo = @('


  █████╗ ███████╗██╗   ██╗██████╗ ███████╗    ███╗   ██╗███████╗ ██████╗ ██╗      ██████╗  ██████╗  ██████╗ ███████╗██████╗ 
 ██╔══██╗╚══███╔╝██║   ██║██╔══██╗██╔════╝    ████╗  ██║██╔════╝██╔════╝ ██║     ██╔═══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗
 ███████║  ███╔╝ ██║   ██║██████╔╝█████╗      ██╔██╗ ██║███████╗██║  ███╗██║     ██║   ██║██║  ███╗██║  ███╗█████╗  ██████╔╝
 ██╔══██║ ███╔╝  ██║   ██║██╔══██╗██╔══╝      ██║╚██╗██║╚════██║██║   ██║██║     ██║   ██║██║   ██║██║   ██║██╔══╝  ██╔══██╗
 ██║  ██║███████╗╚██████╔╝██║  ██║███████╗    ██║ ╚████║███████║╚██████╔╝███████╗╚██████╔╝╚██████╔╝╚██████╔╝███████╗██║  ██║
 ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
                                                                                                                           
                                                                             
 Creator: Securethelogs.com / @securethelogs


')

$logo



$grid = Read-Host -Prompt " Enable GUI? (Y/N)"

if ($grid -ne "y"){

    $filter = Read-Host -Prompt " Would you like to filter logs? (Y/N)"
    
}

if ($filter -eq "y"){

    $search = Read-Host -Prompt " Please enter an IP or port"

}


$loc = Read-Host -Prompt " File Location"



if ((Test-path $loc) -eq $false -or ($loc.EndsWith(".JSON")) -eq "False"){ write-host " Error: File does not exist or not JSON format...." -ForegroundColor Red }else{ 


$a = (Get-Content $loc | Out-String)



$b = @($a -split ('}') -replace "]", "" -replace " ","")
$m = @()

foreach ($c in $b){

 if ($c.StartsWith(',{"time')){
  
 $m += $c -replace ',"' , "`n" -replace ',{"' , ""
 
 }

}


$log = @()

foreach ($t in $m){


$i = @($t -split "`n")



    foreach ($v in $i){


    if ($v.StartsWith("time")){$time = $v -replace '"', "" -replace "time:", "TimeStamp: "}
    if ($v.StartsWith("flows") -and $v.contains('rule":')){$name = @($v -split ":")}
        

        if ($v.contains(",I,") -or $v.contains(",O,")){

            
        
            $r = @($v -split ",")

            $rulename = $name[2] -replace '"', ""
            $source = $r[1]
            $destination = $r[2]
            $sourceprt = $r[3]
            $destport = $r[4]
            
                      
            if ($r[5] -eq "T"){$protocol = "TCP" }else{$protocol = "UDP"}
            if ($r[6] -eq "I"){$direction = "Inbound"  }else{$direction = "Outbound"  }
            if ($r[7] -eq 'A"'){$action = "Allowed"}else{$action = "Denied"}

            
            if ($filter -eq "y"){

                            
                if ($source.Contains($search) -or $destination.Contains($search) -or $sourceprt.Contains($search) -or $destport.Contains($search)){

                $log += @{Source=$source;Destination=$destination;SourcePort=$sourceprt;DestinationPort=$destport;Protocol=$protocol;Direction=$direction;Action=$action;} | % { New-Object object | Add-Member -NotePropertyMembers $_ -PassThru }
              
            
            } else {} 

            
            
        } else {$log += @{Source=$source;Destination=$destination;SourcePort=$sourceprt;DestinationPort=$destport;Protocol=$protocol;Direction=$direction;Action=$action;Rule=$rulename} | % { New-Object object | Add-Member -NotePropertyMembers $_ -PassThru }}

        
    
    
    }



 }


} 


  if ($grid -ne "y"){ 

     $log | Format-Table Source, Destination, SourcePort, DestinationPort, Protocol, Direction, Action, Rule 

     } else {
     
            $log | Select-Object Source, Destination, SourcePort, DestinationPort, Protocol, Direction, Action, Rule  | Out-GridView -Title $loc

            }



}
