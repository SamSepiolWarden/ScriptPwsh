# PnP PowerShell - Site columns, Content Type and assign to new SharePoint list


#Connect to SPO
Connect-SPOService -Url 'https://FsoAllsafe-admin.sharepoint.com' 

$Site = Read-Host "Enter the name of the site Url"
$Title = Read-Host "Enter the title of the site"

#Create new site collection
New-SPOSite -Url "https://Fsoallsafe.sharepoint.com/sites/$Site" -Title $Title -Template 'STS#3' -Owner greg.semedo@fsoallsafe.onmicrosoft.com -NoWait -StorageQuota 1000 
if($?)
{Write-Host Site Succesfully created -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop}
#Connect to new site and validate 
Connect-PnPOnline -Url "https://FsoAllsafe.sharepoint.com/sites/$Site" -Interactive -ErrorAction Stop
$List = Read-Host "Enter the Name of your List"
#Create list
New-PnPList -Title $List -Template GenericList -Url "lists/$List"
if($?)
{Write-Host List Succesfully created -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop}
$DisplayName = Read-Host "Enter the display name for the list field"
$InternalName = Read-Host "Enter the internal name of the lis field"
#Create list field
Add-PnPField -List $List -DisplayName $DisplayName -InternalName $InternalName -Type Choice -Group "$Site Group" -AddToDefaultView -Choices "Stockholm","Helsinki","Oslo"
if($?)
{Write-Host Field Succesfully created -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop}
# Add content type to list
$demoList = Get-PnPList "/lists/$Site"
Add-PnPContentTypeToList -List $demoList -DefaultContentType
if($?)
{Write-Host Content Type Succesfully created -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop}
Disconnect-SPOService
Disconnect-PnPOnline


 

