#!/bin/bash

# Pere Casellas, Stefan Feuz
# http://www.laboratoridenvol.com
# General Public License GNU GPL 3.0

# .sh file to execute the preprocessor
# go into the process directory
#cd process

#cd $1
#./a.out

dire=$1

# Select executable name
lep_out=${dire##*/}
# Select folder name
lep_dir=${dire%/*}
# Go
cd $lep_dir
# Run
./$lep_out
