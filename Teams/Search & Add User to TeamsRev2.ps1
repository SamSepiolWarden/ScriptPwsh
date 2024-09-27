Connect-MicrosoftTeams

$User = Read-Host -Prompt "Enter the Name of the mailbox to add"
$Teams = Read-Host -Prompt "Enter the Name of the Team to add" 

try {
    $GroupId = (Get-Team -DisplayName $Teams).GroupId

    if($GroupId) {
        Write-Host "Teams name found" -ForegroundColor Green
    }
}
catch {
    Write-Host "The process is stopped because teams name was not found" -ForegroundColor Red
    Disconnect-MicrosoftTeams
    return
}

$Role = Read-Host -Prompt "Enter the Role of the user to add"

try {
    $UserInTeams = Get-TeamUser -GroupId $GroupId | Where-Object {$_.User -eq $User}

    if($UserInTeams) {
        Write-Host "$User is already a member of $Teams" -ForegroundColor Red
        Disconnect-MicrosoftTeams
    } else {
        Add-TeamUser -GroupId $GroupId -User $User -Role $Role
        Write-Host "$User has been added to $Teams" -ForegroundColor Green
    }
}
catch {
    Write-Error -ForegroundColor Red
}

Disconnect-MicrosoftTeams


