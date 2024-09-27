 #Parameters
 $AdminCenterURL="https://fsoallsafe-admin.sharePoint.com"
 $SiteURL = "https://fsoallsafe.sharepoint.com/sites/sitename"
    
 #Add 5 GB to the existing site
 $QuotaIncrease = 5 
     
 #Setup Credentials to connect
 Connect-SPOService -Url $AdminCenterURL
           
 #Get the Site Collection
 $Site = Get-SPOSite -Identity $SiteURL -Detailed
     
 #Calculate New Storage Quota
 $CurrentStorage = $Site.StorageQuota
 $NewStorage = $CurrentStorage + ($QuotaIncrease * 1024)
    
 #increase storage quota in sharepoint online
 Set-SPOSite -Identity $SiteURL -StorageQuota $NewStorage
 if($?)
 {Write-Host "Storage Quota set from '$CurrentStorage' to '$NewStorage'" -ForegroundColor Green}
 else
 {Write-Host -ErrorAction Stop -ForegroundColor Red}
 Disconnect-SPOService