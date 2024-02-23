# This script was created by ltx0101

# Check if running with administrator privileges, and if not, relaunch as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Menu
$choice = Read-Host @"
Choose:
1. Clean
2. Optimize
3. Clean and Optimize
4. Manage Services
0. Exit
"@

if ($choice -eq "1") {
    Write-Host "Cleaning temporary files..."
    Remove-Item -Path "$env:temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:userprofile\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Temporary files cleaned."

    $restartChoice = Read-Host "Do you want to restart your PC now? (Y/N)"
    if ($restartChoice -eq "Y") {
        Shutdown /r /f /t 0
    }
    else {
        Write-Host "Restart cancelled."
        Read-Host "Press Enter to exit"
    }
}

if ($choice -eq "2") {
    sfc /scannow
    chkdsk /F C:
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc /scannow

    $restartChoice = Read-Host "Do you want to restart your PC now? (Y/N)"
    if ($restartChoice -eq "Y") {
        Shutdown /r /f /t 0
    }
    else {
        Write-Host "Restart cancelled."
        Read-Host "Press Enter to exit"
    }
}

if ($choice -eq "3") {
    Write-Host "Cleaning temporary files..."
    Remove-Item -Path "$env:temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:userprofile\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*" -Force -Recurse -ErrorAction SilentlyContinue
	Write-Host "Done!"

    Write-Host "This is going to take a while..."
    sfc /scannow
    chkdsk /F C:
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc /scannow

    $restartChoice = Read-Host "Do you want to restart your PC now? (Y/N)"
    if ($restartChoice -eq "Y") {
        Shutdown /r /f /t 0
    }
    else {
        Write-Host "Restart cancelled."
        Read-Host "Press Enter to exit"
    }
}

if ($choice -eq "4") {
    $services = @(
    "wuauserv"         # Windows Update
    "BITS"             # Background Intelligent Transfer Service
    "SysMain"          # Superfetch (Windows 10 and later)
    "SSDPSRV"          # SSDP Discovery
    "WSearch"          # Windows Search
    "WbioSrvc"         # Windows Biometric Service
    "Spooler"          # Print Spooler
    "RemoteRegistry"   # Remote Registry
    "wercplsupport"    # Windows Error Reporting Service
    "DPS"              # Diagnostic Policy Service
    "TermService"      # Remote Desktop Services
    "WpcMonSvc"        # Parental Control
    "DiagTrack"        # Connected User Experiences and Telemetry
    "MapsBroker"       # Downloader Maps
    "wisvc"            # Windows Insider Service
    "icssvc"           # Windows Mobile Hotspot Service
    "CertPropSvc"      # Certificate Propagation
    "OneSyncSvc_4f43c" # OneSync
)

# Function to enable a service
function Enable-Service {
    param([string]$serviceName)
    Set-Service -Name $serviceName -StartupType Automatic
    Start-Service -Name $serviceName
}

# Function to disable a service
function Disable-Service {
    param([string]$serviceName)
    Stop-Service -Name $serviceName -Force
    Set-Service -Name $serviceName -StartupType Disable
}

# Main script
while ($true) {
    Clear
    Write-Host "Choose an action for the services:"
    Write-Host "1. Enable"
    Write-Host "2. Disable"
    Write-Host "3. Quit"

    $choice = Read-Host "Enter your choice (1, 2, or 3)"

    switch ($choice) {
        1 {
            foreach ($service in $services) {
                Enable-Service -serviceName $service
            }
            Write-Host "Services enabled."
        }
        2 {
            foreach ($service in $services) {
                Disable-Service -serviceName $service
            }
            Write-Host "Services disabled."
        }
        3 {
            Write-Host "Exiting script."
            exit
        }
        default {
            Write-Host "Invalid choice. Please enter 1, 2, or 3."
        }
    }
}
}

if ($choice -eq "0") {
    Exit
}
Read-Host 'Press Enter to exit'