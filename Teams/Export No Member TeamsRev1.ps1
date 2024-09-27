Connect-AzureAD

#Get all user
$alluser = Get-AzureADUser -All:$true

$teams = Read-Host -Prompt "Enter the group object id"

# Initialize an array to hold users who are members of a team
$teamMembers = @()

# Boucle pour verifier si l'utilisateur est membre

foreach ($user in $alluser) {
    $userId = $user.ObjectId

    #Verifier si l'utilisateur est membre de l'equipe
    $ismember = (Get-AzureADUserMembership -ObjectId $userId).ObjectId -contains $teams

    #Verification si l'utilisateur a une adresse sociabble.com
    $hasSociabbleEmail = $user.Mail -like "*@sociabble.com"

    #Si l'utilisateur n'est pas membre de l'equipe, l'ajouter au tableau
    if (-not $ismember -and $hasSociabbleEmail) {
        $teamMembers += [PSCustomObject]@{
            'Object ID' = $user.ObjectId
            'Display Name' = $user.DisplayName
            'UPN' = $user.UserPrincipalName
            }
        }
    }

    #Exporter la liste des utilisateurs non membre du teams vers un csv
    $teamMembers | Export-csv -Path "C:\Test\NoMemberOfTeams.csv"

Disconnect-AzureAD