Connect-MgGraph
#entrer l'utilisateur a ajouter aux channels
$User = Read-Host -Prompt "Entrer le nom de l'utilisateur a ajouter aux channels"
#Chercher l'dentifiant de l'utilisateur
$UserId = get-mguser -Filter "displayName eq '$User'" | Select-Object Id
if ($?) {
    Write-Host "L'utilisateur $User a ete trouver" -ForegroundColor Green
}
else {
    Write-Host "L'utilisateur $User n'a pas ete trouver" -ForegroundColor Red -ErrorAction Stop | Write-Host "Can't continue the process" | Disconnect-MgGraph
}
$Roles = Read-Host "Member/Owner"
$Params = @{
	"@odata.type" = "microsoft.graph.aadUserConversationMember"
	roles = @(
		"$Roles"
	)
	"user@odata.bind" = "https://graph.microsoft.com/Beta/users('$UserId.Id')"
}

#entrer le nom de l'equipe
$Team = Read-Host -Prompt "Entrer le nom de l'equipe"

#Chercher l'dentifiant de l'equipe
$TeamId = get-mgteam -Filter "displayName eq '$Team'" 
if ($?) {
    Write-Host "L'equipe $Team a ete trouver" -ForegroundColor Green
}
else {
    Write-Host "L'equipe $Team n'a pas ete trouver" -ForegroundColor Red -ErrorAction Stop | Write-Host "Can't continue the process" | Disconnect-MgGraph
}
#Afficher les channels de l'equipe
$Channels = get-mgteamchannel -TeamId $TeamId.Id
Write-Host "Les channels de l'equipe $Team sont :"
foreach ($channel in $Channels) {
    Write-Host "- $($channel.DisplayName)"
}

#entrer le nom du channel
$Channel = Read-Host -Prompt "Entrer le nom du channel"
#Chercher l'dentifiant du channel
$ChannelId = get-mgteamchannel -TeamId $TeamId.Id | Where-Object {$_.DisplayName -eq "$Channel"} | Select-Object Id


#Ajouter l'utilisateur au channel
New-MgTeamChannelMember -TeamId $TeamId.Id -ChannelId $ChannelId -BodyParameter $Params
if ($?) {
    Write-Host "L'utilisateur $User a ete ajoute au channel avec succes" -ForegroundColor Green
}
else {
    Write-Host "L'utilisateur $User n'a pas pu etre ajouter au channel" -ForegroundColor Red -ErrorAction Stop | Write-Host "Can't continue the process" | Disconnect-MgGraph}

    #Creer une loop pour ajouter l'utilisateur a d'autres channels
    $Add = Read-Host -Prompt "Voulez-vous ajouter l'utilisateur a d'autres channels ? (O/N)"
    while ($Add -eq "O") {
        $Channel1 = Read-Host -Prompt "Entrer le nom du channel"
        #Chercher l'dentifiant du channel
        $ChannelId1 = get-mgteamchannel -TeamId $TeamId.Id | Where-Object {$_.DisplayName -eq "$Channel1"} | Select-Object Id
        New-MgTeamChannelMember -TeamId $TeamId.Id -ChannelId $ChannelId1 -BodyParameter $Params
        if ($?) {
            Write-Host "L'utilisateur $User a ete ajouter au channel avec succes" -ForegroundColor Green
        }
        else {
            Write-Host "L'utilisateur $User n'a pas pu être ajoute au channel" -ForegroundColor Red -ErrorAction Stop | Write-Host "Stop the process" | Disconnect-MgGraph}
        $Add = Read-Host -Prompt "Voulez-vous ajouter l'utilisateur a d'autres channels ? (O/N)"
    }
    if ($Add -eq "N") {
        Write-Host "L'utilisateur $User n'a pas ete ajouter a d'autres channels" -ForegroundColor Green | Disconnect-MgGraph
    }

    