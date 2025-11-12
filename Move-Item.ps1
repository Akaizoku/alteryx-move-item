# Parameters
$Source      = '.\Input\sample.csv'
$Destination = '.\Output\'
$Log         = '.\log.csv'

# Create target directory if required
if (-not (Test-Path -LiteralPath $Destination)) {
    try { $Null = New-Item -ItemType "Directory" -Path $Destination -Force -ErrorAction "Stop" } catch {}
}

# Move file
try {
    $File = Move-Item -LiteralPath $Source -Destination $Destination -PassThru -Force -ErrorAction "Stop"
    $Entry = [PSCustomObject]@{
        "Timestamp" = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        "Source"    = $Source
        "Status"    = "Moved"
        "Target"    = $File.FullName
    }
}

# Handle eventual errors
catch {
    $Entry = [PSCustomObject]@{
        "Timestamp" = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        "Source"    = $Source
        "Status"    = "Error"
        "Target"    = $PSItem.Exception.Message
    }
}

# Export log
Export-Csv -Path $Log -InputObject $Entry -NoTypeInformation -Append -Force
