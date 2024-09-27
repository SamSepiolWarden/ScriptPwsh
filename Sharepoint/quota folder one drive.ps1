$AdminSiteURL="https://fsoallsafe-admin.sharepoint.com"
 
#Connect to SharePoint Online Admin Center
Connect-SPOService -Url $AdminSiteURL
 
#Get all Personal Site collections and export to a Text file
$OneDriveSites = Get-SPOSite -Template "SPSPERS" -Limit ALL -includepersonalsite $True
 
$Result=@()
# Get storage quota of each site
Foreach($Site in $OneDriveSites)
{
    $Result += New-Object PSObject -property @{
    URL = $Site.URL
    Owner= $Site.Owner
    Size_inMB = $Site.StorageUsageCurrent
    StorageQuota_inGB = $Site.StorageQuota/1024
    }
}
 
$Result | Format-Table
 
#Export the data to CSV
$Result | Export-Csv "C:\Users\GregorySemedo\Downloads\OneDrive.csv" -NoTypeInformation
if($?)
{Write-Host Succesfully export -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}
Disconnect-SPOService