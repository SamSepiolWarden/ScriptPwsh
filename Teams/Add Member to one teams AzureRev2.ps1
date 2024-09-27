Connect-AzureAd

$UsersList = Import-Csv -Path C:\Test\NoMemberOfTeams.csv

$teamId = Read-Host -Prompt "Enter the object id of the teams"

foreach ($user in $UsersList) {
    $userId = $user.ObjectId
    $displayName = $user.DisplayName
    
# Vérifier si l'utilisateur est déjà membre de l'équipe
$Members = Get-AzureADGroupMember -ObjectId $teamId | Select-Object -ExpandProperty ObjectId
    $isMember = $Members -contains $userId

if (-not $isMember) {
        # Ajouter l'utilisateur à l'équipe
        Add-AzureADGroupMember -ObjectId $teamId -RefObjectId $user.ObjectID
        
        Write-Host "L'utilisateur '$user.DisplayName' a été ajouté à l'équipe avec l'ID '$teamId'." -ForegroundColor Green
    } else {
        Write-Host "L'utilisateur '$user.DisplayName' est déjà membre de l'équipe avec l'ID '$teamId'." -ForegroundColor Red
    }
}
    


Disconnect-AzureAd
