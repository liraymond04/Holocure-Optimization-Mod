#!/bin/bash

# Check if a folder is provided as an argument
if [ -z "$1" ]; then
    echo "Please provide a folder as an argument."
    exit 1
fi

# Get the folder from the command-line argument
folder="$1"

# Find the first DLL file in the specified folder
dll_path=$(find "$folder" -maxdepth 1 -type f -name "*.dll" | head -n 1)

# Check if a DLL file is found
if [ -z "$dll_path" ]; then
    echo "No DLL files found in the specified folder."
    exit 1
fi

# Extract the version number using a regular expression
version_number=$(echo "$dll_path" | grep -oP '[-]v\d+(\.\d+){0,2}' | sed 's/^-v//')

# Check if the version number is found
if [ -z "$version_number" ]; then
    echo "Version number not found in the DLL path: $dll_path"
else
    # Print the version number
    echo "$version_number"
fi
