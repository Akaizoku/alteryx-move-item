# ------------------------------------------------------------------------------
# * Modules
# ------------------------------------------------------------------------------
Import-Module -Name "PSAYX"

# ------------------------------------------------------------------------------
# * Parameters
# ------------------------------------------------------------------------------
$Name               = "Move Item Macro" # Name of the package
$Author             = "Florian CARRIER" # Author
$Version            = "1.0.1"           # Version number
$CategoryName       = "Developer"       # Tool category
$Description        = "This macro enables users to move files from one location to another by leveraging PowerShell's Move-Item function."
$Icon               = "icon.png"        # Package icon
$CompressionLevel   = "Optimal"         # YXI compression level

# ------------------------------------------------------------------------------
# * Prepare package content
# ------------------------------------------------------------------------------
# Create temporary package folder
$Root    = Split-Path -Parent $PSScriptRoot
$Package = Join-Path -Path $Root -ChildPath "YXI"
New-Item -Path $Package -ItemType "Directory" -Force | Out-Null
# Select files to include in the package
$ExcludeDirs  = @(".git", "Resources", "YXI")
$ExcludeExact = @("README.md", "LICENSE")
$ExcludeLike  = @("*.bak", ".git*", "*.yxi")
Get-ChildItem -Path $Root -Force |
  Where-Object {
    $ItemName = $PSItem.Name
    $ItemName -notin $ExcludeDirs -and
    $ItemName -notin $ExcludeExact -and
    -not ($ExcludeLike | Where-Object { $ItemName -like $PSItem })
  } |
  Copy-Item -Destination $Package -Recurse -Force
Copy-Item -Path $Icon -Destination "$Package\icon.png" -Force
# Resolve package path
$Path = Resolve-Path -Path $Package

# ------------------------------------------------------------------------------
# * Build YXI
# ------------------------------------------------------------------------------
New-AlteryxPackage -Path $Path -Name $Name -Author $Author -Version $Version -CategoryName $CategoryName -Description $Description -Icon "icon.png" -CompressionLevel $CompressionLevel -Unattended

# ------------------------------------------------------------------------------
# * Clean-up
# ------------------------------------------------------------------------------
Remove-Item -Path $Path -Recurse -Force