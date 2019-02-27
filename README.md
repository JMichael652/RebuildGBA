# RebuildGBA

## Introduction

RebuildGBA is a project that automates a common task for a CS 2261 TA:
rebuilding a student's code with 1) the TA's Makefile, and 2) the student's
code and Makefile SOURCES. Ordinarily, this involves a lot of manually copying
files and copy-pasting lines from the Makefile.

## What it does

The project does all of its work with a Bash script called "rebuild\_gba.sh". The script does the following things:
1. Copies the entire project directory into a new directory with the prefix "\_rebuild\_" followed by the original name of the project.
2. Copies the user's Makefile into the new directory, replacing the one that is already there.
3. Replaces the SOURCES in the new Makefile with the SOURCES from the original Makefile.
4. Rebuilds the new project directory with "make clean" and "make build".

## Usage

To run the tool, execute the included bash script "rebuild\_gba.sh"

The script can be run from anywhere, provided that an argument is given for the directory of the Makefile of the project you want to rebuild. If you leave this argument off, it assumes the current working directory is the one you want to rebuild.

### Examples

`bash rebuild_gba.sh ~/Desktop/ExampleProject`
This rebuilds the ExampleProject located on the Desktop.
**Note:** Unless you are currently located in the same directory as the rebuild\_gba.sh script (as in the above example), you will need give bash the path to the script in order to execute it.

`bash ~/PathToYourScript/rebuild_gba.sh`
This rebuilds the project in the user's current working directory.

## Bugs

If you encounter any bugs, please send an email describing it (and the terminal output, if possible) to jmichael652@gmail.com
