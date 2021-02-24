#!/bin/bash
#---------------------------------------------------------------------
# search_and_replace
# 20210119
# Search and replace strings inside a Tcl project
# Intended to put [::msgcat::mc "Chain"] instead of "Chain"
# Works OK, but be carefull whit replacements!

# Recursive search 
# grep -nr '[-]text ["]Apply["]'

# String substitution
#grep -RiIl '[-]text ["]Apply["]' | xargs sed -i 's/[-]text ["]Apply["]/-text [::msgcat::mc "Apply"]/g'

#grep -RiIl '[-]text ["]OK["]' | xargs sed -i 's/[-]text ["]OK["]/-text [::msgcat::mc "OK"]/g'

#grep -RiIl '[-]text ["]Cancel["]' | xargs sed -i 's/[-]text ["]Cancel["]/-text [::msgcat::mc "Cancel"]/g'

#grep -RiIl '[-]text ["]Help["]' | xargs sed -i 's/[-]text ["]Help["]/-text [::msgcat::mc "Help"]/g'


# Using scape to "\"
# grep -RiIl '[-]text ["]Apply [\]nNew line["]' | xargs sed -i 's/[-]text ["]Apply [\]nNew line["]/-text [::msgcat::mc "Apply \\nNew line"]/g'

#grep -RiIl '[-]message ["]All changed data will be lost[.][\]nDo you really want to close the window?["]' | xargs sed -i 's/[-]message ["]All changed data will be lost[.][\]nDo you really want to close the window?["]/-message [::msgcat::mc "All changed data will be lost.\\nDo you really want to close the window?"]/g'

# -text
#grep -RiIl '[-]text ["]Num["]' | xargs sed -i 's/[-]text ["]Num["]/-text [::msgcat::mc "Num"]/g'
#grep -RiIl '[-]text ["]Widths["]' | xargs sed -i 's/[-]text ["]Widths["]/-text [::msgcat::mc "Widths"]/g'
#grep -RiIl '[-]text ["]xini["]' | xargs sed -i 's/[-]text ["]xini["]/-text [::msgcat::mc "xini"]/g'
#grep -RiIl '[-]text ["]xfin["]' | xargs sed -i 's/[-]text ["]xfin["]/-text [::msgcat::mc "xfin"]/g'
#grep -RiIl '[-]text ["]Upper["]' | xargs sed -i 's/[-]text ["]Upper["]/-text [::msgcat::mc "Upper"]/g'
#grep -RiIl '[-]text ["]Lower["]' | xargs sed -i 's/[-]text ["]Lower["]/-text [::msgcat::mc "Lower"]/g'
grep -RiIl '[-]text ["] OK ["]' | xargs sed -i 's/[-]text ["] OK ["]/-text [::msgcat::mc " OK "]/g'


# -title
#grep -RiIl '[-]title ["]Cancel["]' | xargs sed -i 's/[-]title ["]Cancel["]/-title [::msgcat::mc "Cancel"]/g'






