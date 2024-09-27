# Connect to Microsoft Graph and MS Online services
Connect-MgGraph
Connect-MsolService


#Loop to ask user to activate
$AskUser = "Y"

while ($AskUser -eq "Y") {
    

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
$Confirmation = Read-Host -Prompt "Are you sure you want to Activate credentials for $($UserInput.Count) users? (Y/N)"
if ($Confirmation -ne "Y") {
    Write-Host "Operation cancelled" -ForegroundColor Red
    return
}

# Initialize an array to store the results
$ResultArray = @()

foreach ($User in $UserInput) {
    # Extract the UserPrincipalName
    $Username = $User.UserPrincipalName

    # Attempt to Atcivate the user's credential
    Set-MsolUser -UserPrincipalName $Username -BlockCredential $false

    # Check if the command was successful
    if ($?) {
        $message = "Credential Activated for $Username"
        Write-Host $message -ForegroundColor Green
    }
    else {
        $message = "Credential not Atcivated for $Username"
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

$AskUser = Read-Host -Prompt "Do you want to Activate credentials for another user? (Y/N)"
}




# Disconnect from the services
Disconnect-MgGraph



