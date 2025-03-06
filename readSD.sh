#!/bin/bash

# powershell.exe Start-Process powershell.exe -ArgumentList "usbipd list" -Verb RunAs

# Launching usbipd bind command in elevated PowerShell (RunAs)
powershell.exe -Command "Start-Process powershell.exe -ArgumentList 'usbipd bind --busid 1-2' -Verb RunAs"

# Launching usbipd attach command in elevated PowerShell (RunAs)
powershell.exe -Command "Start-Process powershell.exe -ArgumentList 'usbipd attach --wsl --busid 1-2' -Verb RunAs"

sleep 5

# Run python script to upload SD card hex
cd /mnt/c/Users/LAGER/torch_spaaro
cd ./teensy_mtp_cli
python3 uploadHex.py
python3 uploadHex.py

powershell.exe -Command "Start-Process powershell.exe -ArgumentList 'usbipd attach --wsl --busid 1-2' -Verb RunAs"

sleep 5

# Run python host to read data from SD card
python3 SD_host.py

sleep 5

# Convert .bfs file to .mat
cd "/mnt/c/Users/LAGER/torch_spaaro/mat_converter"
mkdir build
cd build
cmake ..
make -j6
./mat_converter /mnt/c/Users/LAGER/torch_spaaro/malt1_1.bfs

# Visualize data
cd "/mnt/c/Users/LAGER/torch_spaaro"
python3 plotData.py