Connect-MicrosoftTeams

$User = Read-Host -Prompt "Enter the Name of the mailbox to add"

$Teams = Read-Host -Prompt "Enter the Name of the Team to add" 
$GroupId = Get-Team -DisplayName $Teams | Select-Object -ExpandProperty GroupId
if($?)
{Write-Host Teams name found -ForegroundColor Green}
else {
    Write-Error | Write-Host "The process is stop" |Disconnect-MicrosoftTeams
}
$Role = Read-Host -Prompt "Enter the Role of the user to add"

$UserInTeams = Get-Team -DisplayName $Teams | Get-TeamUser -GroupId $GroupId | Where-Object {$_.User -eq $User}

if($UserInTeams)
{Write-Host $User is already a member of $Teams -ForegroundColor Red | Disconnect-MicrosoftTeams}
else {
    Write-Host $User is not a member of $Teams -ForegroundColor Green | Add-TeamUser -GroupId $GroupId -User $User -Role $Role | Write-Host $User has been added to $Teams -ForegroundColor Green
}
Disconnect-MicrosoftTeams

