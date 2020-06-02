
$filesfound = @()
$wordsfound = @()
$keywrdfound = @()

Write-Output ""
Write-Output "Please Select An Option:"
Write-Output ""
Write-Output "Option 1: Crawl for files"
Write-Output "Option 2: Crawl file content for keyword"
Write-Output ""


$opt = Read-Host -Prompt "Option:"
if ($opt -ne "1" -and $opt -ne "2"){exit}


if ($opt -eq "1"){

$keywrd = Read-Host -Prompt "Filename:"

$a= @(Get-ChildItem C:\ | Where-Object {$_.Name -ne "Windows" -and $_.Name -ne "Program Files" -and $_.Name -ne "Program Files (x86)"})


foreach ($i in $a){

$keysearch = Get-Childitem -Path $i.FullName -Recurse -force -ErrorAction SilentlyContinue -Include *$keywrd*
$keywrdfound += $keysearch

}

Write-Output ""
Write-Output "Files Found:"
Write-Output ""
$keywrdfound.FullName
Write-Output ""

}



if ($opt -eq "2"){

$keywrd = Read-Host -Prompt "Keyword:"

Write-Output ""

Write-Output "Where should we crawl?"
Write-Output ""
Write-Output "Option 1: Targeted Directory"
Write-Output "Option 2: Full Directory"

$scan = Read-Host -Prompt "Option"
Write-Output ""

if ($scan -eq "1"){$scn = Read-Host -Prompt "Directory to crawl"}
if ($scan -eq "2"){$scn = "C:\"}
if ($scan -ne "1" -and $scan -ne "2"){exit}

Write-Output ""
Write-Output "Searching for supported files....log, txt, doc, docx, xlsx, xls, csv"
Write-Output ""

$a= @(Get-ChildItem $scn | Where-Object {$_.Name -ne "Windows" -and $_.Name -ne "Program Files" -and $_.Name -ne "Program Files (x86)"})

foreach ($i in $a){

$formatsfound = @(Get-Childitem -Path $i.FullName -Recurse -force -ErrorAction SilentlyContinue -Include *.log, *.txt, *.docx, *.doc, *.xlsx, *.xls, *.csv)
$filesfound += $formatsfound.Fullname

}


Foreach ($d in $filesfound){

if ($d -like "*.log" -or $d -like "*.txt"){

$lg = Get-Content -Path $d | Select-String -Pattern "$keywrd"

if ($lg -ne $null){

Write-Output "Found in: $d"

}

} # End of Log Search


# Find in Word docs

if ($d -like "*.doc" -or $d -like "*.docx"){

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$wrd = $word.Documents.Open($d).Content.find.execute("$keywrd")

if ($wrd -eq "True"){

Write-Output "Found in: $d"

}


$word.Quit()

} # End of Word Search


# Find in Excel

if ($d -like "*.csv" -or $d -like "*.xls" -or $d -like "*.xlsx"){

$excl = New-Object -ComObject Excel.Application
$excl.Visible = $false
$workbook = $excl.Workbooks.Open($d)
$worksheets = @($workBook.sheets)

foreach ($sheet in $worksheets){

$ex = $sheet.Cells.Find("$keywrd")

}


if ($ex -ne $null){

Write-Output "Found in: $d"

}


$workbook.close()
$excl.quit()

} # End of Excel search


} # End of crawl


}


