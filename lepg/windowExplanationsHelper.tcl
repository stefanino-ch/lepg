#---------------------------------------------------------------------
#
#  Methods needed in all windows to display the help text in the
#  yellow help field
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------


#----------------------------------------------------------------------
#  proc SetHelpBind
#  Initial setup of the bind functions for the input fields
#
#  IN:      Element for which the bind must be setup
#           VarName name of the field
#           HelpField Help field variable to be updated
#  OUT:     N/A
#----------------------------------------------------------------------
proc SetHelpBind { Element VarName HelpField} {
    bind $Element <Enter> [list SetHelpText 1 $VarName $HelpField]
    bind $Element <Leave> [list SetHelpText 0 $VarName $HelpField]
}

#----------------------------------------------------------------------
#  SetHelpText
#  Controls the help text display in the Explanations window
#
#  IN:      Focus     The value indicating if the field has currently the focus or note
#           Var       Name of the Field
#           HelpField HelpField Help field variable to be updated
#  OUT:     N/A
#----------------------------------------------------------------------
proc SetHelpText { Focus Var HelpField } {
    global $HelpField

    if { $Focus == 1} {
        # display a help text
        set $HelpField [::msgcat::mc $Var]
    } else {
        set $HelpField ""
    }
}
