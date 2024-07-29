# AdminSDHolder ACL Modification Script

This PowerShell script modifies the Access Control Lists (ACLs) of the AdminSDHolder object in Active Directory to add specific permissions for a user or group. This can be used to test and understand the impact of changes to the AdminSDHolder ACLs in a controlled environment.

## Prerequisites

1. **PowerShell 5.1 or later**
2. **Active Directory module for Windows PowerShell**
3. **Administrative privileges in the domain**

## Setup

### Creating Test Users

Before running the script, you need to create some test users in your Active Directory environment.

1. **Admin User**

   This user will have elevated privileges necessary to perform the modifications.

```powershell
New-ADUser -Name "Admin User" -GivenName "Admin" -Surname "User" -SamAccountName "admin" -UserPrincipalName "admin@yourdomain.com" -Path "CN=Users,DC=yourdomain,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true
   Add-ADGroupMember -Identity "Domain Admins" -Members "admin"
````

2. **Test User**
    
    This user will be granted additional permissions in the AdminSDHolder ACL.
    
    `New-ADUser -Name "Test User" -GivenName "Test" -Surname "User" -SamAccountName "testuser" -UserPrincipalName "testuser@yourdomain.com" -Path "CN=Users,DC=yourdomain,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true`
    
3. **Regular User**
    
    This user is for testing regular access.
    
    `New-ADUser -Name "Regular User" -GivenName "Regular" -Surname "User" -SamAccountName "regularuser" -UserPrincipalName "regularuser@yourdomain.com" -Path "CN=Users,DC=yourdomain,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true`
    

## Usage

1. **Download the Script**
    
    Save the provided PowerShell script in a file named `AdminSDHolderChange.ps1`.
    
2. **Run the Script**
    
    Open PowerShell with administrative privileges and execute the following command, replacing the parameters with your actual values:
    
    `.\AdminSDHolderChange.ps1 -DomainControllerName "DC1" -AdminSDHolderDN "CN=AdminSDHolder,CN=System,DC=yourdomain,DC=com" -IdentityToAdd "testuser" -Domain "yourdomain"`
    
    - **DomainControllerName**: The name of your domain controller (e.g., `DC1`).
    - **AdminSDHolderDN**: The Distinguished Name of the AdminSDHolder object (e.g., `CN=AdminSDHolder,CN=System,DC=yourdomain,DC=com`).
    - **IdentityToAdd**: The username to which you want to grant additional permissions (e.g., `testuser`).
    - **Domain**: Your domain name (e.g., `yourdomain`).
