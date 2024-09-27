$siteUrl = "https://sociabble-admin.sharepoint.com"
$exportFile = "C:\Users\GregorySemedo\Desktop\SPOAcces.csv"
$userList = import-csv "C:\Test\SPOUserList.csv"
$siteList = import-csv "C:\Test\sites.csv"

# Connect to SharePoint Online
Connect-SPOService -Url $siteUrl

# En-tête du fichier csv
"Nom de l'utilisateur, URL du site,Rôle" | Out-File $exportFile

foreach ($site in $siteList) {
    $siteUrl = $site.Url
    foreach ($user in $userList) {
        $userName = $user.User
        $user = Get-SPOUser -Site $siteUrl -LoginName $userName
        if ($user -ne $null) {
            $permissions = Get-SPOGroupMember -Site $siteUrl -LoginName $userName
            $permissionLevel = $permissions.Roles
            $line = "$($user.UserLogin),$($siteUrl),$($permissionLevel)"
            $line | Out-File $exportFile -Append
        }
    }
}


Disconnect-SPOService