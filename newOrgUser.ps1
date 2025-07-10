Write-Host "Starting new AD user creation..."

# Prompt for input
$FirstName = Read-Host "Enter first name"
$LastName  = Read-Host "Enter last name"
$Role      = Read-Host "Enter role"

# Sanity check
if (-not $FirstName -or -not $LastName -or -not $Role) {
    Write-Host "Missing input. All fields are required." -ForegroundColor Red
    exit
}

# Derived values
$DisplayName    = "$FirstName $LastName"
$SamAccountName = ($FirstName.Trim() + $LastName.Trim()).ToLower()
$EmailAddress   = "$($FirstName.ToLower()).$($LastName.ToLower())@test.local"
$today          = Get-Date -Format "MMddyyyy"
$PasswordPlain  = "$($FirstName.ToUpper())$($LastName.ToUpper())$today"
$PasswordSecure = ConvertTo-SecureString $PasswordPlain -AsPlainText -Force

# Role-based mapping
switch ($Role.ToLower()) {
    "hr_users"          { $Department = "HR"; $Title = "HR Specialist"; $Group = "HR_Users" }
    "hr_managers"       { $Department = "HR"; $Title = "HR Manager"; $Group = "HR_Managers" }
    "it_admins"         { $Department = "IT"; $Title = "IT Administrator"; $Group = "IT_Admins" }
    "it_helpdesk"       { $Department = "IT"; $Title = "IT Helpdesk"; $Group = "IT_Helpdesk" }
    "sales_users"       { $Department = "Sales"; $Title = "Sales Representative"; $Group = "Sales_Users" }
    "sales_managers"    { $Department = "Sales"; $Title = "Sales Manager"; $Group = "Sales_Managers" }
    "accounting_users"  { $Department = "Accounting"; $Title = "Accountant"; $Group = "Accounting_Users" }
    "accounting_managers" { $Department = "Accounting"; $Title = "Accounting Manager"; $Group = "Accounting_Managers" }
    default {
        Write-Host "Unknown role: $Role" -ForegroundColor Red
        Stop-Transcript
        Read-Host "Press Enter to exit"
        exit
    }
}

# Create the AD user
Write-Host "Creating user '$DisplayName' in '$Department' OU..."
New-ADUser -Name $DisplayName `
           -SamAccountName $SamAccountName `
           -UserPrincipalName "$SamAccountName@test.local" `
           -DisplayName $DisplayName `
           -EmailAddress $EmailAddress `
           -Title $Title `
           -Department $Department `
           -AccountPassword $PasswordSecure `
           -Enabled $true `
           -Path "OU=$Department,DC=test,DC=local" `
           -ChangePasswordAtLogon $true

Write-Host "AD User created successfully: $SamAccountName" -ForegroundColor Green
Write-Host "Temporary password: $PasswordPlain"

# Add to group
Write-Host "Adding '$SamAccountName' to group '$Group'..."
Add-ADGroupMember -Identity $Group -Members $SamAccountName

Write-Host "Group assignment completed."
