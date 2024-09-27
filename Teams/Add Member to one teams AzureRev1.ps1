Connect-AzureAd

$UsersList = Import-Csv -Path C:\Test\NoMemberOfTeams.csv

$teamId = Read-Host -Prompt "Enter the object id of the teams"

foreach ($user in $UsersList) {
    $userId = $UsersList.ObjectId
    $displayName = $UsersList.DisplayName
    
# Vérifier si l'utilisateur est déjà membre de l'équipe
    $isMember = (Get-AzureADUserMembership -ObjectId $userId).ObjectId -contains $teamId
    

}

Disconnect-AzureAd
