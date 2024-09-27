# Connect to services
Connect-MgGraph
Connect-MsolService
Connect-AzureAD

# Function to create a new user and return the user's ID
function New-User {
    param (
        [string]$email,
        [string]$displayName,
        [string]$password  # Changed to string
    )

    # Check if the user already exists
    $existingUser = Get-MsolUser -UserPrincipalName $email -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Host "User $email already exists. Skipping creation."
        return $null
    }

    try {
        # Create new user
        New-MsolUser -DisplayName $displayName -UserPrincipalName $email -UsageLocation FR -Password $password -BlockCredential $true -ForceChangePassword $false
        Write-Host "User $email created successfully."
    } catch {
        Write-Host "Failed to create user $email. Error: $_"
        return $null
    }
    
    # Get and return the newly created user's ID
    $UserId1 = get-mguser -Filter "UserPrincipalName eq '$email'" | Select-Object Id
    return $UserId1.Id
    Start-Sleep -s 5
}

# Use a plain password (for example purposes)
$plainPassword = "Sociabble2023!" 

# Loop through the numbers 1 to 30 to create users
for ($i = 1; $i -le 30; $i++) {
    $email = "aiworkshop$i@sociabble.com"
    $displayName = "Ai Workshop $i"
    $UserId = New-User -email $email -displayName $displayName -password $plainPassword
    Start-Sleep -s 5
    $UserGet = get-mguser -Filter "DisplayName eq '$displayName'" | Select-Object Id
    Start-Sleep -s 5
    if ($UserId) {
        Add-AzureADGroupMember -GroupId "a1c69f19-283a-405d-b5c7-c89ecab5f63f" -RefObjectId $UserGet.Id
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


