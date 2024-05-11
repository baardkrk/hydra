#!/bin/bash

# USB Hub parameters (adjust these based on your `uhubctl` output)
HUB_LOCATION="1-1"
DEVICE_PORT="2"

# Temperature thresholds (in millidegrees Celsius)
TEMP_HIGH=65000 # Example: 65 degrees Celsius
TEMP_LOW=50000  # Example: 50 degrees Celsius

# Function to control USB power
control_usb_power() {
    local action=$1
    uhubctl -l $HUB_LOCATION -p $DEVICE_PORT -a $action
}

# Main loop
while true; do
    # Read CPU temperature
    temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    
    # Compare temperature and control USB power
    if [ $temp -ge $TEMP_HIGH ]; then
        echo "Temperature high ($temp), turning USB power off."
        control_usb_power off
    elif [ $temp -le $TEMP_LOW ]; then
        echo "Temperature low ($temp), turning USB power on."
        control_usb_power on
    fi

    # Wait for a bit before checking again
    sleep 60 # Check every 60 seconds
done
