#!/bin/bash

DISPLAY1_DP_ADDRESS="0x0f"
DISPLAY1_HDMI_ADDRESS="0x12"

DISPLAY2_DVI1_ADDRESS="0x03"
DISPLAY2_VGA_ADDRESS="0x01"

BUS_DISPLAY_1=3
BUS_DISPLAY_2=6

VCP_INPUT_SOURCE=0x60

get_current_input_source() {
	local bus=$1
	local input_source=$(ddcutil getvcp $VCP_INPUT_SOURCE --bus=$bus | grep -oP '\(sl=\K[^)]+')
	if [ -z "$input_source" ]; then
		echo "Error: Failed to retrieve input source for bus $bus"
	else
		echo "$input_source"
	fi
}

toggle_input_source_display_1() {
	local current_source=$(get_current_input_source $BUS_DISPLAY_1)
	if [ "$current_source" == "$DISPLAY1_DP_ADDRESS" ]; then
		ddcutil setvcp $VCP_INPUT_SOURCE $DISPLAY1_HDMI_ADDRESS --bus=$BUS_DISPLAY_1 --sleep-multiplier .1
		echo "Switched Display 1 to $DISPLAY1_HDMI_ADDRESS"
	elif [ "$current_source" == "$DISPLAY1_HDMI_ADDRESS" ]; then
		ddcutil setvcp $VCP_INPUT_SOURCE $DISPLAY1_DP_ADDRESS --bus=$BUS_DISPLAY_1 --sleep-multiplier .1
		echo "Switched Display 1 to $DISPLAY1_DP_ADDRESS"
	else
		echo "Unknown input source for Display 1: $current_source"
	fi
}

toggle_input_source_display_2() {
	local current_source=$(get_current_input_source $BUS_DISPLAY_2)
	if [ "$current_source" == "$DISPLAY2_DVI1_ADDRESS" ]; then
		ddcutil setvcp $VCP_INPUT_SOURCE $DISPLAY2_VGA_ADDRESS --bus=$BUS_DISPLAY_2 --sleep-multiplier .1
		echo "Switched Display 2 to $DISPLAY2_VGA_ADDRESS"
	elif [ "$current_source" == "$DISPLAY2_VGA_ADDRESS" ]; then
		ddcutil setvcp $VCP_INPUT_SOURCE $DISPLAY2_DVI1_ADDRESS --bus=$BUS_DISPLAY_2 --sleep-multiplier .1
		echo "Switched Display 2 to $DISPLAY2_DVI1_ADDRESS"
	else
		echo "Unknown input source for Display 2: $current_source"
	fi
}

toggle_input_source_display_1
toggle_input_source_display_2
