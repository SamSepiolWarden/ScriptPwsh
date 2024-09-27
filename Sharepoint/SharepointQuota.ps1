Connect-PnPOnline -Interactive
$CSVFilePath = "C:\Users\GregorySemedo\Downloads\LargeFiles.csv"
$FileData = @()
$DocumentLibrairies = Get-PnPList | Where-Object {$_.BaseType -eq "DocumentLibrary" -and $_.Hidden -eq $False}
ForEach ($List in $DocumentLibrairies)
{
Write-host "Processing Library:"$List.Title -f Yellow
$Files = Get-PnPListItem -List $List -PageSize 500 | Where-Object{($_.FieldValues.FileLeafRef -like"*.*") -and
($_.FieldValues.SMTotalFileStreamSize/1MB -gt 100)}
ForEach ($File in $Files)
{
$FileData += [PSCustomObject][ordered]@{
Library = $List.Title
FileName = $File.FieldValues.FileLeafRef
URL = $File.FieldValues.FileRef
Size = [math]::Round(($File.FieldValues.SMTotalFileStreamSize/1MB,2),2)
}
}
}
$FileData | Sort-object Size -Descending
$FileData | Export-Csv -Path $CSVFilePath -NoTypeInformation
