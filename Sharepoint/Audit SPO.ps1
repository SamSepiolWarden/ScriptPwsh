Connect-SPOService -Url https://fsoallsafe-admin.sharepoint.com

# Import the CSV file with the list of sites
$sites = Import-Csv -Path "C:\Test\sites.csv"

# Initialize an empty array to store the group members
$allMembers = @()

# Loop through each site in the CSV file
foreach ($site in $sites) {
    $siteUrl = $site.URL
    Write-Host "Processing site $siteUrl"

    # Get all the groups in the current site
    $groups = Get-SPOSiteGroup -Site $siteUrl

    # Loop through each group and get its members
    foreach ($group in $groups) {
        Write-Host "Processing group $($group.Title)"
        $members = Get-SPOUser -Site $siteUrl -Group $group.Title

        # Add the group members to the array
        $allMembers += $members
    }
}

# Export all the members to a CSV file
$allMembers | Export-Csv -Path "C:\Test\Export.csv" -NoTypeInformation

Disconnect-SPOService