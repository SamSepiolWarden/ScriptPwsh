# Connect to services
Connect-MgGraph
Connect-MsolService
Connect-AzureAD

# Function to create a new user and return the user's ID
function New-User {
    param (
        [string]$email,
        [string]$displayName,
        [String]$password
    )

    # Check if the user already exists
    $existingUser = Get-MsolUser -UserPrincipalName $email -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Host "User $email already exists. Skipping creation."
        return $null
    }

    try {
        # Create new user
        New-MsolUser -DisplayName $displayName -UserPrincipalName $email -UsageLocation FR -Password $password -BlockCredential $true
        Write-Host "User $email created successfully."
    } catch {
        Write-Host "Failed to create user $email. Error: $_"
        return $null
    }
    
   
}
 # Get and return the newly created user's ID
 $UserId1 = get-mguser -Filter "DisplayName eq '$displayname'" | Select-Object Id
 return $UserId.Id
 Start-Sleep -s 5
# Convert a plain password to SecureString (for example purposes)
$plainPassword = "Sociabble2023!"


# Loop through the numbers 1 to 30 to create users
for ($i = 1; $i -le 30; $i++) {
    $email = "aiworkshop$i@sociabble.com"
    $displayName = "Ai Workshop $i"
    $userId = New-User -email $email -displayName $displayName -password $plainPassword
    
    if ($userId) {
        Add-AzureADGroupMember -GroupId "a1c69f19-283a-405d-b5c7-c89ecab5f63f" -RefObjectId $UserId1.Id
        if ($?) {
            Write-Host "User $email added to group"
        }
        else {
            Write-Host "Failed to add user $email to group"
        }
    }
    
    # Output progress
    Write-Host "Processed user $i out of 30"
}

Disconnect-MgGraph


