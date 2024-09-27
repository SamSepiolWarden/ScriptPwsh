# Function to safely disconnect from services
function SafeDisconnect {
    param (
        [string]$Service
    )
    try {
        if ($Service -eq "Graph") {
            Disconnect-MgGraph -Confirm:$false
        } elseif ($Service -eq "Exchange") {
            Disconnect-ExchangeOnline -Confirm:$false
        }
    } catch {
        Write-Host "Error disconnecting from $Service"
    }
}

# Connect to Microsoft Graph
try {
    Connect-MgGraph
} catch {
    Write-Host "Error connecting to Microsoft Graph"
    return
}

# Prompt for a display name of the user to remove
$UserToRemove = Read-Host -Prompt "Enter the display name of the user to remove"

# Search for the user
try {
    $users = Get-MgUser -Filter "displayName eq '$UserToRemove'"
} catch {
    Write-Host "Error searching for user"
    SafeDisconnect "Graph"
    return
}

if ($users.Count -eq 0) {
    Write-Host "User not found, please enter the correct name"
    SafeDisconnect "Graph"
    return
}

# UserPrincipalName
$AliasUserRemove = $users.UserPrincipalName

# Connect to Exchange Online
try {
    Connect-ExchangeOnline
} catch {
    Write-Host "Error connecting to Exchange Online"
    SafeDisconnect "Graph"
    return
}

# Prompt to add a mailing list name
$MailingList = Read-Host -Prompt "Enter the name of the Mailing List"

# Alias for mailing list
$AliasMailingList = $AliasUserRemove

# Add members to the mailing list
$MemberstoML = Read-Host -Prompt "Enter the alias of the user (ex : gregory.semedo@sociabble,...)"

# Remove the user
try {
    Remove-MgUser -UserId $users.Id
    Write-Host "User $UserToRemove removed"
} catch {
    Write-Host "Error removing user"
    SafeDisconnect "Exchange"
    SafeDisconnect "Graph"
    return
}

# Create the mailing list
try {
    New-DistributionGroup -DisplayName $MailingList -Members $MemberstoML -Name $AliasMailingList -Alias "fw_$UserToRemove@azureechoboostbrainsonic491.onmicrosoft.com"
    Write-Host "Mailing List $MailingList created"
} catch {
    Write-Host "Error creating mailing list"
    SafeDisconnect "Exchange"
    SafeDisconnect "Graph"
    return
}
Update-DistributionGroup -Identity $MailingList -PrimarySmtpAddress $AliasMailingList
if($?) {
    Write-Host "Mailing List $MailingList updated"
}
else {
    Write-Host "Error updating mailing list"
}
# Safely disconnect from services
SafeDisconnect "Exchange"
SafeDisconnect "Graph"
