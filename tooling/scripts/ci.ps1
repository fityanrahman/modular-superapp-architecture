param(
    [ValidateSet('all', 'shared', 'modules', 'apps')]
    [string]$Target = 'all'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$groups = @{
    shared  = @('contracts', 'core', 'design_system')
    modules = @('modules/food', 'modules/ride', 'modules/wallet')
    apps    = @(
        'apps/consumer_app',
        'apps/food_dev_app',
        'apps/ride_dev_app',
        'apps/wallet_dev_app'
    )
}

$selected = switch ($Target) {
    'all'     { $groups.shared + $groups.modules + $groups.apps }
    'shared'  { $groups.shared }
    'modules' { $groups.modules }
    'apps'    { $groups.apps }
}

$failures = @()

foreach ($relative in $selected) {
    $packagePath = Join-Path $root $relative
    Write-Host "`n=== $relative ===" -ForegroundColor Cyan

    Push-Location $packagePath
    try {
        flutter pub get
        if (-not $?) { throw 'pub get failed' }

        flutter analyze
        if (-not $?) { throw 'analyze failed' }

        flutter test
        if (-not $?) { throw 'tests failed' }
    }
    catch {
        Write-Host "FAILED: $relative" -ForegroundColor Red
        $failures += $relative
    }
    finally {
        Pop-Location
    }
}

if ($failures.Count -gt 0) {
    Write-Host "`nFailures in: $($failures -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host "`nAll checks passed." -ForegroundColor Green
