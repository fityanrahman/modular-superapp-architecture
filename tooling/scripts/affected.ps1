param(
    [string]$Base = 'origin/main'
)

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location $root
try {
    $changed = git diff --name-only "$Base...HEAD"
}
finally {
    Pop-Location
}

$packages = [ordered]@{
    'contracts'       = 'contracts/'
    'core'            = 'core/'
    'design_system'   = 'design_system/'
    'food'            = 'modules/food/'
    'ride'            = 'modules/ride/'
    'wallet'          = 'modules/wallet/'
    'consumer_app'    = 'apps/consumer_app/'
    'food_dev_app'    = 'apps/food_dev_app/'
    'ride_dev_app'    = 'apps/ride_dev_app/'
    'wallet_dev_app'  = 'apps/wallet_dev_app/'
}

$affected = @()
foreach ($name in $packages.Keys) {
    $prefix = $packages[$name]
    if ($changed | Where-Object { $_ -like "$prefix*" }) {
        $affected += $name
    }
}

if ($affected.Count -eq 0) {
    Write-Host 'No packages affected.'
}
else {
    Write-Host 'Affected packages:'
    $affected | ForEach-Object { Write-Host "  - $_" }
}
