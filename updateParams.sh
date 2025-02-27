#!/bin/bash

# Launching usbipd bind command in elevated PowerShell (RunAs)
powershell.exe -Command "Start-Process powershell.exe -ArgumentList 'usbipd bind --busid 1-2' -Verb RunAs"

# Launching usbipd attach command in elevated PowerShell (RunAs)
powershell.exe -Command "Start-Process powershell.exe -ArgumentList 'usbipd attach --wsl --busid 1-2' -Verb RunAs"

sleep 5

python3 updateParams.py
