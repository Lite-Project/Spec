#
# Quick Spec
#
# Made by: https://github.com/Lite-Project
#
# Version v0.1
#
# W.I.P
#

$RT = @()
$info = Get-ComputerInfo
$R = (Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Speed, MemoryType)
$RSM = @{
    'DDR3' = 800
    'DDR4' = 2133
    'DDR5' = 4801
}
foreach ($module in $R) {
    foreach ($type in $RSM.GetEnumerator() | Sort-Object Value -Descending) {
        if ($module.Speed -ge $type.Value) {
            $RType = $type.Key
            break
        }
    }
    $RT += $Rtype
}
Set-Clipboard @"
CPU: $($info.csprocessors.name)

RAM: $($info.CsPhyicallyInstalledMemory / 1MB) GB
    Number of Sticks: $($r.Manufacturer.Count)
    Manufacturer('s): $($r.Manufacturer -join ', ')
    Type: $($RT[0])
    Speed: $(($R.Speed | Measure-Object -Minimum).Minimum) Mhz

GPU: $(Get-CimInstance Win32_VideoController | Select -ExpandProperty Name)
    Driver Version: $(Get-CimInstance Win32_VideoController | Select -ExpandProperty DriverVersion)

MOTHERBOARD: $($info.CsManufacturer)
    Model: $($info.CsModel)

WARNING: MEMORY TYPE CAN BE WRONG
"@