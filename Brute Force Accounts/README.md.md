# Fuerza Bruta en Usuarios Locales y de Dominio

Este repositorio contiene scripts de PowerShell para realizar ataques de fuerza bruta en usuarios locales y de dominio de un servidor, intentando autenticarse de forma remota.

## Advertencia

**Estos scripts deben ser utilizados únicamente en entornos controlados y con autorización explícita. Realizar ataques de fuerza bruta sin permiso es ilegal y puede tener graves consecuencias. Asegúrate de tener todos los permisos necesarios antes de ejecutar estos scripts en cualquier entorno de producción.**

## Requisitos

- PowerShell 5.0 o superior
- Permisos de administrador
- Archivos de texto con listas de usuarios y contraseñas

## Configuración

1. **Prepara los archivos de entrada:**
   - `usuarios.txt`: Un archivo de texto con una lista de nombres de usuario, cada uno en una nueva línea.
   - `contraseñas.txt`: Un archivo de texto con una lista de posibles contraseñas, cada una en una nueva línea.

2. **Configura los scripts:**
   - Guarda los scripts en archivos llamados `fuerza_bruta_local.ps1` y `fuerza_bruta_dominio.ps1`.

3. **Habilitar PSRemoting en el servidor objetivo:**
   - En el servidor objetivo, asegúrate de que PowerShell Remoting está habilitado:
     ```powershell
     Enable-PSRemoting -Force
     ```
   - Asegúrate de que el firewall permite el tráfico de PowerShell Remoting:
     ```powershell
     Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any -Action Allow
     ```

## Uso

### Fuerza Bruta en Usuarios Locales
#### Parámetros

- `-usuariosFilePath`: Ruta al archivo de texto que contiene la lista de usuarios locales.
- `-contraseñasFilePath`: Ruta al archivo de texto que contiene la lista de contraseñas.
- `-servidor`: Dirección IP del servidor objetivo.

### Fuerza Bruta en Usuarios de Dominio

Ejecuta el script desde PowerShell pasando los parámetros correspondientes. Por ejemplo:

`.\fuerza_bruta_dominio.ps1 -usuariosFilePath "C:\ruta\usuarios.txt" -contraseñasFilePath "C:\ruta\contraseñas.txt" -dominio "tu_dominio" -servidor "192.168.1.10"`

#### Parámetros
- `-usuariosFilePath`: Ruta al archivo de texto que contiene la lista de usuarios de dominio.
- `-contraseñasFilePath`: Ruta al archivo de texto que contiene la lista de contraseñas.
- `-dominio`: Nombre del dominio al que pertenecen los usuarios.
- `-servidor`: Dirección IP del controlador de dominio.

## Ejemplo de Archivos de Entrada

### usuarios.txt

```bash
usuario1 
usuario2 
usuario3
```
### contraseñas.txt

```bash
password1
password2 
password3
```