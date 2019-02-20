#!/bin/bash

# Handle argument for user Makefile
if [[ "$1" != "" ]]; then
	user_makefile="$1"
else
	echo "No user Makefile passed as argument"
	exit 1
fi

# Handle argument for student project path
if [[ "$2" != "" ]]; then
	student_dir="$2"
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
mkdir "$rebuild_dir"

# Copy the student files to the rebuilt directory
# Although rebuild_dir is a child, cp does not recurse and throws warning
cp -r "$student_dir"/* "$rebuild_dir/" 2> /dev/null # Hide warning
rm -r "$rebuild_dir/${rebuild_dir##*/}" # Remove stub of recursive copy

