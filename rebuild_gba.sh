#!/bin/bash

# Find path to .config file
config_path=${0/%rebuild_gba.sh/.config}
printf "Path to config: %s\n" "$config_path"

# Create .config if none present
if [[ ! -e "$config_path" ]]; then
	echo "user_makefile=" > "$(pwd)/$config_path"
fi

# Handle argument for user Makefile
if [[ "$1" != "" ]]; then
	user_makefile="${1%%Makefile}"
else
	echo "No user Makefile passed as argument"
	exit 1
fi

# Ensure user has a Makefile here
if [[ ! -e "$user_makefile/Makefile" ]]; then
	echo "No Makefile at $user_makefile"
	exit 1
fi

# Handle argument for student project path
if [[ "$2" != "" ]]; then
	student_dir="${2%%/}"
else
	student_dir="$(pwd)"
fi

# Ensure student has a Makefile here
if [[ ! -e "$student_dir/Makefile" ]]; then
	echo "No student Makefile at $student_dir"
	echo "This tool does not support Makefiles at non-root locations"
	exit 1
fi

# Demonstrate results
printf "User Makefile: %s, Student Directory: %s\n" "$user_makefile" "$student_dir"

# Make the directory to store the rebuilt project
rebuild_dir="$student_dir/_rebuild_${student_dir##*/}"

# If folder already exists, remove all remnants of previous rebuild
if [[ -e "$rebuild_dir" ]]; then
	rm -r "$rebuild_dir"
fi
mkdir "$rebuild_dir"

# Copy the student files to the rebuilt directory
# Although rebuild_dir is a child, cp does not recurse and throws warning
cp -r "$student_dir"/* "$rebuild_dir/" 2> /dev/null # Hide warning
rm -r "$rebuild_dir/${rebuild_dir##*/}" # Remove stub of recursive copy

# Obtain SOURCES from student Makefile
student_src=$(awk '/^SOURCES/{print}' "$student_dir/Makefile")
printf "Student sources: %s\n" "$student_src"

# Replace rebuild_dir/Makefile with user Makefile and student Makefile SOURCES
# Code snippet taken from https://stackoverflow.com/a/28232494
awk -v var="$student_src" '/^SOURCES/ { print var; next } 1' \
	"$user_makefile/Makefile" > "$rebuild_dir/Makefile"

# Clean the rebuilt directory
make clean -C "$rebuild_dir"

# Build the project
make build -C "$rebuild_dir"

