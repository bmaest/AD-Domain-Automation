# AD Deployment Kit

This repository serves as a collection of miscellaneous PowerShell scripts used during the implementation of a simulated Active Directory domain for a fictional medium-sized company.

A full project breakdown, including architecture, design decisions, and implementation details, can be found here:  
**[https://brandonmaestas.com/ad-project](https://brandonmaestas.com/ad-project)**

---

## Script Index

Below is a growing list of scripts included in this repository, along with a brief description of their purpose and usage.

### `dataExport.ps1`

**Description:**  
Exports key Active Directory objects into XML format for use with a custom-built faux PowerShell terminal hosted on [brandonmaestas.com](https://brandonmaestas.com/ad-project).

**Exports the following objects:**
- Computers
- Domain Controllers
- GPOs
- Group Members
- Groups
- Organizational Units (OUs)
- Users

**Usage:**
```powershell
.\dataExport.ps1
```

### `computerAudit.ps1`
**Description:**  
Collects system inventory data from domain-joined machines and exports it as structured XML. This data is used to simulate asset tracking and auditing within the mock AD console hosted on [brandonmaestas.com](https://brandonmaestas.com/ad-project).

**Exports the following objects:**
- Computer name
- OS version
- CPU
- RAM
- Installed applications (name, version, publisher)
- Local machine certificates (subject and expiration)

**Usage:**
```powershell
.\computerAudit.ps1
```

### `newOrgUser.ps1`
**Description:**  
Automates the process of user creation in Active Directory. The script prompts for first name, last name, and role, then generates standardized user attributes including email, display name, username, password, and group assignment.

Password follows the convention: FIRSTLASTMMDDYYYY and is configured to be changed at first logon.

**Writes to the following fields:**
- Name
- DisplayName
- SamAccountName
- UserPrincipalName
- EmailAddress
- Title
- Department
- AccountPassword
- Enabled
- ChangePasswordAtLogon
- Path

**Usage:**
```powershell
.\newOrgUser.ps1
```
