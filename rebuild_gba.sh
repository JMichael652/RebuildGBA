#!/bin/bash

# Handle argument for user Makefile
if [ "$1" != "" ]; then
	user_makefile="$1"
else
	echo "No user Makefile passed as argument"
	exit 1
fi

# Handle argument for student project path
if [ "$2" != "" ]; then
	student_dir="$2"
else
	student_dir="$(pwd)"
fi

# Demonstrate results
printf "User Makefile: %s, Student Directory: %s\n" "$user_makefile" "$student_dir"

