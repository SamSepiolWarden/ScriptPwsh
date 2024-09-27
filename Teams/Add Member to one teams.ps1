Connect-MicrosoftTeams

$UsersList = Import-Csv -Path C:\Test\NoMemberOfTeams.csv

$teamId = Read-Host -Prompt "Enter the object id of the teams"

foreach ($user in $UsersList) {
    $userId = $UsersList.ObjectId
    $displayName = $UsersList.DisplayName
    
    try {
        # Ajouter l'utilisateur à l'équipe
        Add-TeamUser -GroupId $teamId -User $userId -Role Member
        
        Write-Host "L'utilisateur '$displayName' a été ajouté à l'équipe avec l'ID '$teamId'."
    } 
    catch
     {
        Write-Host "L'utilisateur '$displayName' est déjà membre de l'équipe avec l'ID '$teamId'."
    }
}

Disconnect-MicrosoftTeams
