#Parameters
$Sitename = Read-Host "Write your site name"
$SiteURL = "https://fsoallsafe.sharepoint.com/sites/$Sitename"
$FolderSiteRelativeURL =  Read-Host "Write your folder relative url"
 
#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -Interactive
     
#Get the folder
$Folder = Get-PnPFolder -Url $FolderSiteRelativeURL -Includes ListItemAllFields
 
#Get the total Size of the folder - with versions
Write-host "Size of the Folder:" $([Math]::Round(($Folder.ListItemAllFields.FieldValues.SMTotalSize.LookupId/1KB),2))
Disconnect-PnPOnline