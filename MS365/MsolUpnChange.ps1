BEGIN {
    TRY {
        $CurrentUPN = Read-Host "Enter the name of the current UPN"
        $TemporaryUPN = Read-Host "Enter the name of the temporary UPN"
        $NewUPN = Read-Host "Enter the name of the new UPN"

        # Exchange Online - Validate we find the user
        Write-Verbose -Message "[BEGIN] Current Information"
        if (Get-MsolDomain) {
            Get-MsolUser -UserPrincipalName $CurrentUPN -ErrorAction Stop
        }
        else {
            Write-Error "[BEGIN] Does not seem connected to Office365"
            break
        }
    }
    CATCH {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
PROCESS {
    TRY {
        Write-Verbose -Message "[PROCESS] Processing changes"
        $Splatting = @{ }

        if ($PSBoundParameters['Credential']) { $Splatting.credential = $Credential }

        # Set the current MSOL user to the default OnMicrosoft.com UPN Suffix
        Set-MsolUserPrincipalName -UserPrincipalName $CurrentUPN -NewUserPrincipalName $TemporaryUPN -ErrorAction Stop | Out-Null
        # Set the user to the new UPN Suffix
        Set-MsolUserPrincipalName -UserPrincipalName $TemporaryUPN -NewUserPrincipalName $NewUPN -ErrorAction Stop | Out-Null


        # Post Change
        Start-Sleep -Seconds 5
        Get-MsolUser -UserPrincipalName $NewUPN
        
        
    }
    CATCH {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

