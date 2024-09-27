Connect-Mggraph
# Add the manager to the user
$Manager = Read-Host -Prompt "Enter the DisplayName of the manager of the user to add"
$ManagerId = (Get-Mguser -Filter "DisplayName eq '$Manager'").id

$UserId = Read-Host -Prompt "Enter the DisplayName of the user to add the manager"
$IDCreation = (Get-Mguser -Filter "DisplayName eq '$UserId'").id

$Params = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/users/$ManagerId"
} | ConvertTo-Json


Set-MgUserManagerByRef -UserId $IDCreation  -BodyParameter $Params
if ($?) {
    Write-Host "Manager $Manager assigned to $UserId" -ForegroundColor Green
}
else {
    Write-Host "Manager $Manager not assigned to $UserId" -ForegroundColor Red
}
Disconnect-Mggraph