# Remote Kerberoasting PowerShell Script

This repository contains a PowerShell script designed to perform a Kerberoasting attack remotely. The script identifies service accounts in Active Directory and extracts their Kerberos ticket hashes, which can then be analyzed for weak passwords.

## Disclaimer

**This script is for educational and authorized penetration testing purposes only. Unauthorized use of this script is illegal and unethical. Ensure you have explicit permission to perform these tests on the target system.**

## Features

- Detects service accounts in Active Directory.
- Extracts Kerberos ticket hashes for detected service accounts.
- Supports remote execution via PowerShell Remoting.
- Saves captured hashes to a specified output file.

## Prerequisites

- PowerShell 5.1 or later.
- Active Directory module for PowerShell.
- PowerShell Remoting enabled on the target machine.

## Setup

### Enable PowerShell Remoting on the Target Machine

On the target machine, open PowerShell as an administrator and run:
```powershell
Enable-PSRemoting -Force
```

## Usage

1. Clone the repository to your local machine:

```bash
git clone https://github.com/Mr-r00t11/RemoteKerberoasting.git 
cd RemoteKerberoasting
```

2. Open PowerShell in the repository directory.
  
3. Run the script with the required parameters:

```powershell
.\RemoteKerberoast.ps1 -RemoteComputerName "RemoteServer01" -Username "domain\username" -Password "password" -OutputFile "kerberoast_hashes.txt"
```

### Parameters

- `-RemoteComputerName`: The name or IP address of the remote computer.
- `-Username`: The username to use for the remote session (format: domain\username).
- `-Password`: The password for the specified user.
- `-OutputFile`: The name of the file where captured hashes will be saved (default: `kerberoast_hashes.txt`).

## Example

`.\RemoteKerberoast.ps1 -RemoteComputerName "RemoteServer01" -Username "domain\administrator" -Password "P@ssw0rd123" -OutputFile "kerberoast_hashes.txt"`

This command will connect to the remote computer `RemoteServer01` using the specified credentials, perform Kerberoasting, and save the captured hashes to `kerberoast_hashes.txt` in the current directory.
