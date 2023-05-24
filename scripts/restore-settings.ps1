$GDLAUNCHER_INSTANCES_PATH="$env:APPDATA\gdlauncher_next\instances"

$COBBLEMON_INSTANCES = Get-ChildItem "$GDLAUNCHER_INSTANCES_PATH" -Directory | Where-Object Name -CLike "Cobblemon*" | Select-Object Name

$OLD_INSTANCE_NAME = ($COBBLEMON_INSTANCES | Select-Object -Index ($COBBLEMON_INSTANCES.count-2)).Name
$NEW_INSTANCE_NAME = ($COBBLEMON_INSTANCES | Select-Object -Index ($COBBLEMON_INSTANCES.count-1)).Name

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
    Write-Output "Your old instance name: $OLD_INSTANCE_NAME is incorrect or doesn't exist."
}
elseif(!(Test-Path -Path $NEW_INSTANCE_PATH)) {
    Write-Output "Your new instance name: $NEW_INSTANCE_NAME is incorrect or doesn't exist."
}
else {
    Write-Output "Please confirm the source and destination for your settings import..."
    Write-Output "Source ($OLD_INSTANCE_NAME): $OLD_INSTANCE_PATH"
    Write-Output "Destination ($NEW_INSTANCE_NAME): $NEW_INSTANCE_PATH"

    $CONFIRMATION = ""
    while($CONFIRMATION -eq "") {
        $CONFIRMATION = Read-Host -Prompt "Would you like to proceed with your settings import? [Y/N]"
    }
    
    if($CONFIRMATION -eq "Y") {
        Copy-Item "$OLD_OPTIONS_PATH" -Destination "$NEW_OPTIONS_PATH"
        Copy-Item "$OLD_CONFIG_PATH" -Destination "$NEW_CONFIG_PATH" -Recurse -Force
        Copy-Item "$OLD_WAYPOINTS_PATH" -Destination "$NEW_WAYPOINTS_PATH" -Recurse -Force
        Copy-Item "$OLD_WORLDMAP_PATH" -Destination "$NEW_WORLDMAP_PATH" -Recurse -Force
        Write-Output "Your Cobblemon settings have been imported!"
    }
    else {
        Write-Output "You have canceled your settings import."
    }
}