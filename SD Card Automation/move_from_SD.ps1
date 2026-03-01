# Get directory this script is in
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$parentDir = Split-Path -Parent $scriptDir

$destinationFolder = Join-Path $parentDir "Data/Teensy"

$fileCopied = $false
$driveLetter = $null

# Find removable drives
$removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object {
    $_.DriveType -eq 2
}

foreach ($drive in $removableDrives) {

    $sourceFile = Join-Path $drive.DeviceID "SdioLogger.csv"

    if (Test-Path $sourceFile) {

     if (!(Test-Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder | Out-Null
        }

        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
        $destinationFile = Join-Path $destinationFolder "CVT_Shift_$timestamp.csv"

        # Copy instead of move
        Copy-Item $sourceFile $destinationFile -Force

        $fileCopied = $true
        $driveLetter = $drive.DeviceID
    }
}

if ($fileCopied -and $driveLetter) {

    # Show popup
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "SdioLogger.csv copied successfully.`nDrive will now be ejected.",
        "Teensy Logger",
        "OK",
        "Information"
    )

    # Safely eject drive
    $shell = New-Object -ComObject Shell.Application
    $shell.Namespace(17).ParseName($driveLetter).InvokeVerb("Eject")
}
