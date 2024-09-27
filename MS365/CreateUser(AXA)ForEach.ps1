# Connect to services
Connect-MgGraph
Connect-MsolService

# Function to create a new user
function New-User {
    param (
        [string]$email,
        [string]$displayName,
        [SecureString]$password
    )

    # Check if the user already exists
    $existingUser = Get-MsolUser -UserPrincipalName $email -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Host "User $email already exists. Skipping creation."
        return
    }

    try {
        # Create new user
        New-MsolUser -DisplayName $displayName -UserPrincipalName $email -UsageLocation FR -Password $password -BlockCredential $true
        Write-Host "User $email created successfully."
    } catch {
        Write-Host "Failed to create user $email. Error: $_"
    }

    # Additional operations like assigning license and adding to group can be included here
}

# Convert a plain password to SecureString (for example purposes)
$plainPassword = "Sociabble2023!" # Replace with a real password
$securePassword = $plainPassword | ConvertTo-SecureString -AsPlainText -Force

# Loop through the numbers 1 to 30 to create users
for ($i = 1; $i -le 30; $i++) {
    $email = "aiworkshop$i@sociabble.com"
    $displayName = "Ai Workshop $i"
    New-User -email $email -displayName $displayName -password $securePassword
}

Disconnect-MgGraph
