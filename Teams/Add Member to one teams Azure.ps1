Connect-AzureAd

$UsersList = Import-Csv -Path C:\Test\NoMemberOfTeams.csv

$teamId = Read-Host -Prompt "Enter the object id of the teams"

foreach ($user in $UsersList) {
    $userId = $UsersList.ObjectId
    $displayName = $UsersList.DisplayName
    
# Vérifier si l'utilisateur est déjà membre de l'équipe
    $isMember = (Get-AzureADUserMembership -ObjectId $userId).ObjectId -contains $teamId
    
    if (-not $isMember) {
        # Ajouter l'utilisateur à l'équipe
        Add-AzureADGroupMember -ObjectId $teamId -RefObjectId $userId
        
        Write-Host "L'utilisateur '$displayName' avec l'ID '$userId' a été ajouté à l'équipe avec l'ID '$teamId'."
    } else {
        Write-Host "L'utilisateur '$displayName' avec l'ID '$userId' est déjà membre de l'équipe avec l'ID '$teamId'."
    }
}

Disconnect-AzureAd
