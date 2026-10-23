Clear-Host
Write-Host " --------------------System och nätverksrapport--------------------" -ForegroundColor Green

# Hämta info från dator
Write-Host "----------Datorinfo----------" -ForegroundColor Blue

$osInfo = Get-ComputerInfo
[PSCustomObject]@{
    Datornamn      = $osInfo.CsName
    Operativsystem = $osInfo.WindowsProductName
    Version        = $osInfo.WindowsVersion
    Byggnummer     = $osInfo.OsBuildNumber
} | Format-Table -AutoSize

# Hämta nätverksinfo/IP
Write-Host "----------Nätverksinfo----------" -ForegroundColor Blue

Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254*" } |
    Select-Object InterfaceAlias, IPAddress, PrefixLength |
    Format-Table -AutoSize
    
# Hämta status för vanliga tjänster
Write-Host "----------Tjänster----------" -ForegroundColor Blue
$services = @("wuauserv", "Spooler", "WinDefend")
Get-Service -Name $services -ErrorAction SilentlyContinue | 
    Select-Object DisplayName, Status, StartType | 
    Format-Table -AutoSize