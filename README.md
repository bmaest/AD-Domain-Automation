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
