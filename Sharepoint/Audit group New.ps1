# Connect to SharePoint Online
Connect-SPOService -Url https://sociabble-admin.sharepoint.com

# En-tête du fichier csv
"Nom de l'utilisateur, URL du site,Rôle" | Out-File $exportFile

foreach ($site in $siteList) {
    $siteUrl = $site.Url
    $siteGroups = Get-SPOSiteGroup -Site $siteUrl
    foreach ($user in $userList) {
        $userName = $user.User
        $user = Get-SPOUser -Site $siteUrl -LoginName $userName
        if ($user -ne $null) {
            $permissions = $siteGroups | ForEach-Object {
                if ($_.Users.LoginName -contains $user.LoginName) {
                    return $_.Title
                }
            }
            $permissionLevel = $permissions -join ","
            $line = "$($user.UserLogin),$($siteUrl),$($permissionLevel)"
            $line | Out-File $exportFile -Append
        }
    }
}

Disconnect-SPOService