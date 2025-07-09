Start-Transcript -Path "C:\Windows\Temp\AssetAudit.log" -Force

$ComputerName = $env:COMPUTERNAME
$UserName     = $env:USERNAME
$OS           = (Get-CimInstance Win32_OperatingSystem).Caption
$CPU          = (Get-CimInstance Win32_Processor).Name
$RAM          = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$Timestamp    = (Get-Date).ToString("s")

$Apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Where-Object { $_.DisplayName } |
        Select-Object DisplayName, DisplayVersion, Publisher

$Certs = Get-ChildItem Cert:\LocalMachine\My | Select-Object Subject, NotAfter

$xml = New-Object System.Xml.XmlDocument
$root = $xml.CreateElement("AssetReport")
$root.SetAttribute("ComputerName", $ComputerName)
$root.SetAttribute("UserName", $UserName)
$root.SetAttribute("Timestamp", $Timestamp)
$xml.AppendChild($root) | Out-Null

$sys = $xml.CreateElement("SystemInfo")
$sys.SetAttribute("OS", $OS)
$sys.SetAttribute("CPU", $CPU)
$sys.SetAttribute("RAM_GB", "$RAM")
$root.AppendChild($sys) | Out-Null

$appsNode = $xml.CreateElement("Applications")
foreach ($app in $Apps) {
    $appNode = $xml.CreateElement("App")
    $appNode.SetAttribute("Name", $app.DisplayName)
    $appNode.SetAttribute("Version", $app.DisplayVersion)
    $appNode.SetAttribute("Publisher", $app.Publisher)
    $appsNode.AppendChild($appNode) | Out-Null
}
$root.AppendChild($appsNode) | Out-Null

$certsNode = $xml.CreateElement("Certificates")
foreach ($cert in $Certs) {
    $certNode = $xml.CreateElement("Cert")
    $certNode.SetAttribute("Subject", $cert.Subject)
    $certNode.SetAttribute("Expires", $cert.NotAfter.ToString("s"))
    $certsNode.AppendChild($certNode) | Out-Null
}
$root.AppendChild($certsNode) | Out-Null

$xml.Save("\\dc01\AssetInventory\$ComputerName.xml")

Stop-Transcript