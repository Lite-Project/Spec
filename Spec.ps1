#
# Quick Spec W.I.P
#
# Made by: https://github.com/Lite-Project
#
# Version v0.2
#
# **NEW**
#
# Added in v0.2
# Using SmBiosMemoryType Property to find Memory type 
# Grabs GPU only gpu if both GPU and APU are present.

$RT = @()
$info = Get-ComputerInfo
$R = (Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Speed, SMBiosMemoryType)
[array]$GPUN = Get-CimInstance Win32_VideoController | Select -ExpandProperty Name
[array]$GPUD = Get-CimInstance Win32_VideoController | Select -ExpandProperty DriverVersion
if ($GPUN.Count -eq 1) {
    $GPUN += "BLANK"
}
if ($GPUD.Count -eq 1) {
    $GPUD += "BLANK"
}
$RTP = @{
    'Unknown' = 0
    'Other' = 1
    'DRAM' = 2
    'Synchronous DRAM' = 3
    'Cache DRAM' = 4
    'EDO' = 5
    'EDRAM' = 6
    'VRAM' = 7
    'SRAM' = 8
    'RAM' = 9
    'ROM' = 10
    'Flash' = 11
    'EEPROM' = 12
    'FEPROM' = 13
    'EPROM' = 14
    'CDRAM' = 15
    '3DRAM' = 16
    'SDRAM' = 17
    'SGRAM' = 18
    'RDRAM' = 19
    'DDR' = 20
    'DDR2' = 21
    'DDR2 FB-DIMM' = 22
    'DDR3' = 23
    'FBD2' = 25
    'DDR4' = 26
    'DDR5' = 34
} # RAM Type Map
foreach ($module in $R) { #Using Type map to determine RAM type
    foreach ($type in $RTP.GetEnumerator() | Sort-Object Value -Descending) {
        if ($module.SMBiosMemoryType -ge $type.Value) {
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

GPU: $($GPUN[0])
    Driver Version: $($GPUD[0])

MOTHERBOARD: $($info.CsManufacturer)
    Model: $($info.CsModel)
"@