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

