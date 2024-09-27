Connect-MgGraph

# Prompt for a display name of the user to remove
$UserToRemove = Read-Host -Prompt "Enter the display name of the user to remove"

# search the user if it exists
$users = Get-MgUser -Filter "displayName eq '$UserToRemove'"
if ($users.Count -eq 0) {
    Write-Host "User not found, need to enter the good name" | Disconnect-MgGraph }
 #Userprincipalname
 $AliasUserRemove = $users.UserPrincipalName

# connect-exchangeonline
Connect-ExchangeOnline

# Prompt to add a mailing list name to create with the alias of the user
$MailingList = Read-Host -Prompt "Enter the name of the Mailing List"

# Prompt to add the alias of the user
$AliasMailingList = $AliasUserRemove

# Add members to the mailing list
$MemberstoML = Read-Host -Prompt "Enter the alias of the user (ex : gregory.semedo@sociabble,...)"

# Remove the user
Remove-MgUser -UserId $users.Id
if ($?) {
    Write-Host "User $UserToRemove removed" } 
else {
    Write-Host "Error removing user" | Write-Error }

Start-Sleep -Seconds 10

# Create the mailing list
New-DistributionGroup -DisplayName $MailingList -Members $MemberstoML -Alias $AliasMailingList
if ($?) {
    Write-Host "Mailing List $MailingList created" } 
else {
    Write-Host "Error creating mailing list" | Write-Error }


# Disconnect from Exchange Online
Disconnect-ExchangeOnline

# Disconnect from Microsoft Graph
Disconnect-MgGraph



