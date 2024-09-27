# Connect to Microsoft Graph
Connect-MgGraph
# Retrieve users with a displayName starting with 'Ai W'
$ListAI = Get-MgUser -Filter "startsWith(displayName,'Ai W')"

# Custom sorting function to sort by the numerical part of the display name
function Sort-DisplayNameNumerically {
    param($user)
    if ($user.DisplayName -match 'Ai Workshop (\d+)$') {
        return [int]$Matches[1]
    } else {
        return [int]::MaxValue
    }
}

# Sort the users by the numerical part in their displayName
$SortedUsers = $ListAI | Sort-Object -Property { Sort-DisplayNameNumerically $_ }

# Output the sorted users
Write-Output "Sorted Users:"
$SortedUsers | ForEach-Object { Write-Output $_.DisplayName }

# Initialize a counter
$i = 1

# Loop through each sorted user in the list
foreach ($User in $SortedUsers) {
    # Update the GivenName and Surname of the user
    $updatedUser = Update-MgUser -UserId $User.Id -GivenName "Ai" -Surname "Workshop $i" -Mail $User.UserPrincipalName
    if ($?) {
        Write-Host "Updated User: $($User.DisplayName) to GivenName: Ai, Surname: Workshop $i succesfully" -ForegroundColor Green
    }
    else {
        Write-Host "Failed to update user: $($User.DisplayName) to GivenName: Ai, Surname: Workshop $i" -ForegroundColor Red
    }

Start-Sleep -s 5
    # Output the updated user information
    Write-Output "Updated User: $($UpdatedUser.DisplayName) to GivenName: Ai, Surname: Workshop $i"
Start-Sleep -s 5
    # Increment the counter
    $i++
}




