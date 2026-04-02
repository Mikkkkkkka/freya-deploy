# For test purposes

param(
    [string]$Path = ".env"
)

$resolvedPath = Join-Path -Path $PSScriptRoot -ChildPath $Path

if (-not (Test-Path -LiteralPath $resolvedPath)) {
    throw "Env file not found: $resolvedPath"
}

Get-Content -LiteralPath $resolvedPath | ForEach-Object {
    $line = $_.Trim()

    if (-not $line -or $line.StartsWith("#")) {
        return
    }

    if ($line.StartsWith("export ")) {
        $line = $line.Substring(7).Trim()
    }

    $separatorIndex = $line.IndexOf("=")
    if ($separatorIndex -lt 1) {
        return
    }

    $name = $line.Substring(0, $separatorIndex).Trim()
    $value = $line.Substring($separatorIndex + 1).Trim()

    if (
        ($value.StartsWith('"') -and $value.EndsWith('"')) -or
        ($value.StartsWith("'") -and $value.EndsWith("'"))
    ) {
        $value = $value.Substring(1, $value.Length - 2)
    }

    [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
    Set-Item -Path "Env:$name" -Value $value
}
