#!/bin/bash

# Find path to .config file
config_path=$(realpath "$0")
config_path=${config_path/%rebuild_gba.sh/.rbgba-config}
printf "Path to config: %s\n" "$config_path"

# Create .config if none present
if [[ ! -e "$config_path" ]]; then
	echo "user_makefile=" > "$config_path"
fi

# Handle reading in user Makefile
user_makefile=$(awk '/^user_makefile=/{print}' "$config_path")
user_makefile=${user_makefile##user_makefile=}

# Ensure user has a Makefile here
if [[ ! -e "$user_makefile/Makefile" ]]; then
	while [[ ! -e "$user_makefile/Makefile" ]]; do
		# Show error only if not first config setting
		if [[ -n "$user_makefile" ]]; then
			echo "No Makefile at $user_makefile"
		fi
		read -p "Path to working Makefile for this system: " \
			user_makefile
		user_makefile=$(realpath "$user_makefile")
		user_makefile=${user_makefile%%Makefile}
	done
	echo "user_makefile=$user_makefile" > "$config_path"
fi

# Handle argument for student project path
if [[ "$1" != "" ]]; then
	student_dir=$(realpath "$1")
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

