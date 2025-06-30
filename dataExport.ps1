# Ensure the ActiveDirectory and GroupPolicy modules are loaded
Import-Module ActiveDirectory
Import-Module GroupPolicy

# Define export directory
$exportDir = "$PSScriptRoot\data"
if (-not (Test-Path -Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir -Force
}

# Export AD Users
Get-ADUser -Filter * -Properties DisplayName, EmailAddress, Title, Department, Enabled, LastLogonDate |
    Select-Object Name, SamAccountName, DisplayName, EmailAddress, Title, Department, Enabled, LastLogonDate |
    Export-Clixml -Path (Join-Path $exportDir "users.xml") -Encoding UTF8

# Export AD Computers
Get-ADComputer -Filter * -Properties OperatingSystem, IPv4Address, Enabled, LastLogonDate |
    Select-Object Name, OperatingSystem, IPv4Address, Enabled, LastLogonDate |
    Export-Clixml -Path (Join-Path $exportDir "computers.xml") -Encoding UTF8

# Export Organizational Units
Get-ADOrganizationalUnit -Filter * |
    Select-Object Name, DistinguishedName, ObjectGUID |
    Export-Clixml -Path (Join-Path $exportDir "ous.xml") -Encoding UTF8

# Export Groups
Get-ADGroup -Filter * -Properties Description |
    Select-Object Name, SamAccountName, GroupScope, Description |
    Export-Clixml -Path (Join-Path $exportDir "groups.xml") -Encoding UTF8

# Export Group Members (flattened)
$groupMembers = @()
Get-ADGroup -Filter * | ForEach-Object {
    $group = $_
    Get-ADGroupMember -Identity $group.DistinguishedName -Recursive | ForEach-Object {
        $groupMembers += [PSCustomObject]@{
            GroupName = $group.Name
            MemberName = $_.Name
            MemberType = $_.objectClass
        }
    }
}
$groupMembers | Export-Clixml -Path (Join-Path $exportDir "groupmembers.xml") -Encoding UTF8

# Export GPOs
Get-GPO -All |
    Select-Object DisplayName, Id, GpoStatus, CreationTime, ModificationTime |
    Export-Clixml -Path (Join-Path $exportDir "gpos.xml") -Encoding UTF8

# Export Domain Controllers
Get-ADDomainController -Filter * |
    Select-Object Name, IPv4Address, Site, OperatingSystem, IsGlobalCatalog |
    Export-Clixml -Path (Join-Path $exportDir "domaincontrollers.xml") -Encoding UTF8

Write-Host "AD domain data exported to: $exportDir"
