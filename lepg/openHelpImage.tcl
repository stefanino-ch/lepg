#---------------------------------------------------------------------
#
#  Opens a help image to view in new window
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

proc OpenHelpImage { imageName } {

    source "globalPreProcVars.tcl"

    global .imah
    global .imah.ima
    global .imah.but

    # Toplevel
    toplevel .imah
#    wm geometry .imah 500x500+100+100
    wm resizable .imah 50 50
    wm title .imah [::msgcat::mc "Help drawing"]
    focus .imah

    frame .imah.fr1 -width 400 -height 10 -bd 2
#    pack  .imah.fr1 -side top -padx 2m -pady 2m -ipadx 2c -ipady 2c
    pack  .imah.fr1 -side top

#    grid .imah.ima     -row 0 -column 0 -sticky e
#    grid .imah.but     -row 1 -column 0 -sticky e

    set img [image create photo -file $imageName]
    label .imah.fr1.lb1 -image $img
    pack  .imah.fr1.lb1 -expand yes -fill both
#    pack  .imah.fr1.lb1 -side top


#    label .imah.fr1.lb2 -text " "
#    label .imah.fr1.lb3 -text [::msgcat::mc "Help drawing"]

#    pack .imah.fr1.lb3 .imah.fr1.lb1 -side top

    button .imah.fr1.holaok -text [::msgcat::mc "OK"] -command {destroy .imah}
    pack .imah.fr1.holaok -padx 20 -pady 10

}

