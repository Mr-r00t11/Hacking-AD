param (
    [string]$DomainControllerName,
    [string]$AdminSDHolderDN,
    [string]$IdentityToAdd,
    [string]$Domain
)

# Establecer la sesión remota
$cred = Get-Credential
$s = New-PSSession -ComputerName $DomainControllerName -Credential $cred

# Ejecutar el script de modificación en la sesión remota
Invoke-Command -Session $s -ScriptBlock {
    param (
        $AdminSDHolderDN,
        $IdentityToAdd
    )

    # Obtener el objeto AdminSDHolder
    $adminSDHolder = Get-ADObject -Identity $AdminSDHolderDN -Properties ntSecurityDescriptor

    # Obtener el ACL actual
    $acl = $adminSDHolder.ntSecurityDescriptor

    # Crear una nueva regla de acceso
    $identity = New-Object System.Security.Principal.NTAccount($IdentityToAdd)
    $adRights = [System.DirectoryServices.ActiveDirectoryRights]::GenericAll
    $type = [System.Security.AccessControl.AccessControlType]::Allow
    $accessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($identity, $adRights, $type)

    # Añadir la nueva regla al ACL
    $acl.AddAccessRule($accessRule)

    # Establecer el nuevo ACL en el objeto AdminSDHolder
    Set-ADObject -Identity $AdminSDHolderDN -Replace @{ntSecurityDescriptor = $acl}

    # Confirmar los cambios
    Write-Output "ACL changes have been applied to AdminSDHolder."
} -ArgumentList $AdminSDHolderDN, "$Domain\$IdentityToAdd"

# Cerrar la sesión remota
Remove-PSSession -Session $s
