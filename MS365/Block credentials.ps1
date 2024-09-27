# Connect to Microsoft Graph and MS Online services
Connect-MgGraph
Connect-MsolService

#Initialize a loop
$Ask = "Y"

while ($Ask -eq "Y") {
    


# Prompt for user input
$UserPrompt = Read-Host -Prompt "Enter the name to search with startwith" 


# Retrieve users whose DisplayName starts with the given input
$UserInput = Get-mgUser -Filter "startsWith(UserPrincipalName, '$UserPrompt')"

# Check if any users were found
if ($UserInput.Count -eq 0) {
    Write-Host "No users found with the given name" -ForegroundColor Red
    return
}

# Prompt for confirmation
$Confirmation = Read-Host -Prompt "Are you sure you want to block credentials for $($UserInput.Count) users? (Y/N)"
if ($Confirmation -ne "Y") {
    Write-Host "Operation cancelled" -ForegroundColor Red
    return
}

# Initialize an array to store the results
$ResultArray = @()

foreach ($User in $UserInput) {
    # Extract the UserPrincipalName
    $Username = $User.UserPrincipalName

    # ASk to block user credential
    $Confim = Read-Host -Prompt "Are you sure you want to block credential for $Username ? (Y/N)"
    if ($Confim -eq "N") {
        Write-Host "$Username not blocked" -ForegroundColor Red
        $Ask = Read-Host -Prompt "Do you want to proceed to the next batch? (Y/N)"
        continue
    }
    elseif ($Confim -eq "Y") {
        <# Action when this condition is true #>
    
    # Attempt to block the user's credential
    Set-MsolUser -UserPrincipalName $Username -BlockCredential $true

    # Check if the command was successful
    if ($?) {
        $message = "Credential blocked for $Username"
        Write-Host $message -ForegroundColor Green
    }
    else {
        $message = "Credential not blocked for $Username"
        Write-Host $message -ForegroundColor Red
    }

    # Add the result to the array
    $ResultArray += @{
        Username = $Username
        Message = $message
    }
}

# Output the results
$ResultArray
$Ask = Read-Host -Prompt "Do you want to proceed to the next batch? (Y/N)"
}
}
# Disconnect from the services
Disconnect-MgGraph



