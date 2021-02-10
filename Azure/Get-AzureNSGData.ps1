[CmdletBinding(DefaultParameterSetName='None')]

param (
    [Parameter(ParameterSetName='GridView')]
    [switch]
    $Gridview,

    [Parameter(ParameterSetName='Csv')]
    [switch]
    $Csv,

    [ipaddress]
    $SrcIPFilter,

    [ipaddress]
    $DstIPFilter,

    [ValidateRange(1,65535)]
    [int]
    $SrcPortFilter,

    [ValidateRange(1,65535)]
    [int]
    $DstPortFilter,

    [ValidateSet('A','D')]
    [char]
    $ActionFilter,

    [ValidateSet('I','O')]
    [char]
    $FlowFilter,

    [switch]
    $Progress

)

$ErrorActionPreference = 'Stop'

$StartTime = Get-Date

$FilePath = Read-Host -Prompt "File Location"

if (-not (Test-Path $FilePath)) {
    Write-Host " Error: File does not exist or not JSON format...." -ForegroundColor Red
}
else { 
    $Records = (Get-Content -Path $FilePath | ConvertFrom-Json).Records
}

$BaseDate = (Get-Date 01.01.1970)

$Output = [System.Collections.ArrayList]@()

$FlowCount = $Records.Properties.Flows.Count
$FlowCounter = 0

Write-Host "Processing $FlowCount flows..."

foreach ($Record in $Records) {
    $Flows = $Record.Properties.Flows

    foreach ($Flow in $Flows) {

        if ($Progress) {
            $FlowCounter++
            Write-Progress -Activity 'Processing flows' -Status "$FlowCounter of $FlowCount" -PercentComplete (($FlowCounter/$FlowCount)*100)
        }

        $Rule = $Flow.Rule

        foreach ($SubFlow in $Flow.Flows) {

            $FlowTuples = $SubFlow.FlowTuples

            # Check filters and continue if a filter is not matched
            if ($PSBoundParameters.Keys -Contains 'ActionFilter') {
                $FlowTuples = $FlowTuples.Where({$_ -match "^.*,$ActionFilter,.*"})
            }
            if ($PSBoundParameters.Keys -Contains 'FlowFilter') {
                $FlowTuples = $FlowTuples.Where({$_ -match "^.*,$FlowFilter,.*"})
            }
            if ($PSBoundParameters.Keys -Contains 'SrcIPFilter') {
                $FlowTuples = $FlowTuples.Where({$_ -match "^\d+,$SrcIPFilter,.*"})
            }
            if ($PSBoundParameters.Keys -Contains 'SrcPortFilter') {
                $FlowTuples = $FlowTuples.Where({$_ -match "^\d+,[0-9.]+,[0-9.]+,$SrcPortFilter,.*"})
            }
            if ($PSBoundParameters.Keys -Contains 'DstIPFilter') {
                $FlowTuples = $FlowTuples.Where({$_ -match "^\d+,[0-9.]+,$DstIPFilter,.*"})
            }
            if ($PSBoundParameters.Keys -Contains 'DstPortFilter') {
                $FlowTuples = $FlowTuples.Where({$_ -match "^\d+,[0-9.]+,[0-9.]+,[0-9]+,$DstPortFilter,.*"})
            }

            foreach ($FlowTuple in $FlowTuples) {
                # Data is broken into comma separated values that we will break down here.
                $Data = $FlowTuple -split ','
                $TimeStamp       = $BaseDate.AddSeconds($Data[0]).ToLocalTime().ToString('HH:mm:ss.fff')
                $SourceIP        = [ipaddress]$Data[1]
                $DestinationIP   = [ipaddress]$Data[2]
                $SourcePort      = $Data[3]
                $DestinationPort = $Data[4]
                $Protocol        = if ($Data[5] -eq 'T') {'TCP'} else {'UDP'}
                $TrafficFlow     = if ($Data[6] -eq 'I') {'Inbound'} else {'Outbound'}
                $Action          = if ($Data[7] -eq 'A') {'Allow'} else {'Deny'}
                $BytesSentToDest = $Data[10]
                $BytesSentToSrc  = $Data[12]

                # Create object and add it to output 
                $Output.Add(
                    [PSCustomObject]@{
                        TimeStamp = $TimeStamp
                        SourceIP  = $SourceIP
                        SourcePort = $SourcePort
                        DestinationIP = $DestinationIP
                        DestinationPort = $DestinationPort
                        Protocol = $Protocol
                        TrafficFlow = $TrafficFlow
                        Action = $Action
                        Rule = $Rule
                    }
                ) > null
            }
            
        }

    }

}

$EndTime = Get-Date
$ExecTime = New-TimeSpan -Start $StartTime -End $EndTime
Write-Host "Execution Time: $($ExecTime.ToString('mm\:ss'))"

if ($GridView) {
    $Output | Out-GridView
}
elseif ($Csv) {
    $Output | Export-Csv -NoTypeInformation -Path "$($FilePath.Split('.')[0]).csv"
}
else {
    $Output | Format-Table -AutoSize
}