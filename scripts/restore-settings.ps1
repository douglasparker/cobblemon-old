$GDLAUNCHER_INSTANCES_PATH="$env:APPDATA\gdlauncher_next\instances"

$SYMBOLS = [PSCustomObject] @{
    CHECKMARK = ([char]8730)
    XMARK = ([char]10799)
}

while([string]::IsNullOrWhitespace($AUTOMATIC_INSTANCE_DETECTION)) {
    $AUTOMATIC_INSTANCE_DETECTION = Read-Host -Prompt "Would you like to use automatic instance detection? [Y/N]"
    if($AUTOMATIC_INSTANCE_DETECTION -eq "y") { $AUTOMATIC_INSTANCE_DETECTION = $true }
    elseif($AUTOMATIC_INSTANCE_DETECTION -eq "n") { $AUTOMATIC_INSTANCE_DETECTION = $false }
    else { $AUTOMATIC_INSTANCE_DETECTION = "" }
}

if($AUTOMATIC_INSTANCE_DETECTION) {
    $COBBLEMON_INSTANCES = Get-ChildItem "$GDLAUNCHER_INSTANCES_PATH" -Directory | Where-Object Name -CLike "Cobblemon*" | Select-Object Name
    
    $OLD_INSTANCE_NAME = ($COBBLEMON_INSTANCES | Select-Object -Index ($COBBLEMON_INSTANCES.count-2)).Name
    $NEW_INSTANCE_NAME = ($COBBLEMON_INSTANCES | Select-Object -Index ($COBBLEMON_INSTANCES.count-1)).Name
    if([string]::IsNullOrWhitespace($OLD_INSTANCE_NAME) -or [string]::IsNullOrWhitespace($NEW_INSTANCE_NAME)) {
        Write-Host -ForegroundColor Red "$($SYMBOLS.XMARK) A source and destination instance was not detected for import."
        Write-Host "Please ensure there are at least two instances before running the import script."
        exit 1
    }
}
else {
    while([string]::IsNullOrWhitespace($OLD_INSTANCE_NAME)) {
        $OLD_INSTANCE_NAME = Read-Host -Prompt "Please enter the source instance name: "
    }
    while([string]::IsNullOrWhitespace($NEW_INSTANCE_NAME)) {
        $NEW_INSTANCE_NAME = Read-Host -Prompt "Please enter the destination instance name: "
    }
}

$OLD_INSTANCE_PATH="$env:APPDATA\gdlauncher_next\instances\$OLD_INSTANCE_NAME"
$NEW_INSTANCE_PATH="$env:APPDATA\gdlauncher_next\instances\$NEW_INSTANCE_NAME"

$OLD_OPTIONS_PATH="$env:APPDATA\gdlauncher_next\instances\$OLD_INSTANCE_NAME\options.txt"
$NEW_OPTIONS_PATH="$env:APPDATA\gdlauncher_next\instances\$NEW_INSTANCE_NAME\options.txt"

$OLD_CONFIG_PATH="$env:APPDATA\gdlauncher_next\instances\$OLD_INSTANCE_NAME\config"
$NEW_CONFIG_PATH="$env:APPDATA\gdlauncher_next\instances\$NEW_INSTANCE_NAME\config"

$OLD_WAYPOINTS_PATH="$env:APPDATA\gdlauncher_next\instances\$OLD_INSTANCE_NAME\XaeroWaypoints"
$NEW_WAYPOINTS_PATH="$env:APPDATA\gdlauncher_next\instances\$NEW_INSTANCE_NAME\XaeroWaypoints"

$OLD_WORLDMAP_PATH="$env:APPDATA\gdlauncher_next\instances\$OLD_INSTANCE_NAME\XaeroWorldMap"
$NEW_WORLDMAP_PATH="$env:APPDATA\gdlauncher_next\instances\$NEW_INSTANCE_NAME\XaeroWorldMap"

if(!(Test-Path -Path $OLD_INSTANCE_PATH)) {
    Write-Host -ForegroundColor Red "$($SYMBOLS.XMARK) The source instance ($OLD_INSTANCE_NAME) doesn't exist at the path: $OLD_INSTANCE_PATH."
    exit 1
}
elseif(!(Test-Path -Path $NEW_INSTANCE_PATH)) {
    Write-Host -ForegroundColor Red "$($SYMBOLS.XMARK) The destination instance ($NEW_INSTANCE_NAME) doesn't exist at the path: $NEW_INSTANCE_PATH"
    exit 1
}
else {
    Write-Host "Please confirm the source and destination for your settings import..."
    Write-Host "Source ($OLD_INSTANCE_NAME): $OLD_INSTANCE_PATH"
    Write-Host "Destination ($NEW_INSTANCE_NAME): $NEW_INSTANCE_PATH"

    $CONFIRMATION = ""
    while($CONFIRMATION -eq "") {
        $CONFIRMATION = Read-Host -Prompt "Would you like to proceed with your settings import? [Y/N]"
    }
    
    if($CONFIRMATION -eq "Y") {
        Copy-Item "$OLD_OPTIONS_PATH" -Destination "$NEW_OPTIONS_PATH"
        Copy-Item "$OLD_CONFIG_PATH" -Destination "$NEW_CONFIG_PATH" -Recurse -Force
        Copy-Item "$OLD_WAYPOINTS_PATH" -Destination "$NEW_WAYPOINTS_PATH" -Recurse -Force
        Copy-Item "$OLD_WORLDMAP_PATH" -Destination "$NEW_WORLDMAP_PATH" -Recurse -Force
        Write-Host -ForegroundColor Green "$($SYMBOLS.CHECKMARK) Your Cobblemon settings have been imported!"
    }
    else {
        Write-Host -ForegroundColor Red "$($SYMBOLS.XMARK) You have canceled your settings import."
    }
}