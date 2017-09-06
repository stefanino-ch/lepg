#----------------------------------------------------------------------
#   proc myAppLeadingEdge
#
#   Define an analytical leading edge
#----------------------------------------------------------------------

 proc myAppLeadingEdge { } {

    global rib nribss

    myApp_lep_r

    set a1_le 609.68
    set b1_le  223.58
    set x1_le 291.5
    set xm_le  539
    set c0_le  40

    set w .datagraph 
    catch {destroy $w} 
    toplevel $w 
    focus $w
    wm title $w "Leading edge definition" 
    wm geometry $w 800x400+50+50

    frame $w.f1 -width 400 -height 400 -bd 2 -relief groove
    frame $w.f2 -width 400 -height 400 -bd 2 -relief groove -bg red
    pack $w.f1 $w.f2 -side left

    canvas $w.f2.c1 -width 400 -height 400 -bg white
    pack   $w.f2.c1 -side top


# Crea el marco para un label. 
    frame $w.f1.m0 
    label $w.f1.m0.l -text "Leading edge parameters: (cm)" -anchor w
    pack  $w.f1.m0 -side top -fill both -padx 2m -pady 0 
    pack  $w.f1.m0.l -side left -padx 1m 

#   Frames for data entry
    frame $w.f1.m1 -width 400
    frame $w.f1.m2 -width 400
    frame $w.f1.m3 -width 400
    frame $w.f1.m4 -width 400
    frame $w.f1.m5 -width 400

    label $w.f1.m1.l1 -text "a1 horizontal ellipse:" -anchor w
    set e1 [entry $w.f1.m1.e1 -relief sunken -width 10]
    pack  $w.f1.m1.l1 $w.f1.m1.e1 -side left -fill both -padx 2m -pady 1m 

    label $w.f1.m2.l1 -text "b1 vertical ellipse:" -anchor w
    set e2 [entry $w.f1.m2.e1 -relief sunken -width 10] 
    pack  $w.f1.m2.l1 $w.f1.m2.e1 -side left -fill both -padx 2m -pady 1m 

    label $w.f1.m3.l1 -text "x1 transition point:" -anchor w
    set e3 [entry $w.f1.m3.e1 -relief sunken -width 10] 
    pack  $w.f1.m3.l1 $w.f1.m3.e1 -side left -fill both -padx 2m -pady 1m 

    label $w.f1.m4.l1 -text "xm half span:" 
    set e4 [entry $w.f1.m4.e1 -relief sunken -width 10] 
    pack  $w.f1.m4.l1 $w.f1.m4.e1 -side left -fill both -padx 2m -pady 1m 

    label $w.f1.m5.l1 -text "c0 le deflection:" 
    set e4 [entry $w.f1.m5.e1 -relief sunken -width 10] 
    pack  $w.f1.m5.l1 $w.f1.m5.e1 -side left -fill both -padx 2m -pady 1m 

    pack $w.f1.m1 $w.f1.m2 $w.f1.m3 $w.f1.m4 $w.f1.m5 -side top -fill both


# Crea el marco donde colocar los botones inferiores. 
    frame $w.f1.buttons -relief groove -borderwidth 2 
    # Inserta el marco en la parte inferior de la ventana. 
    pack $w.f1.buttons -side top -fill x -pady 1m -padx 2m 
    # Crea los botones de aceptar/cancelar. 

    button $w.f1.buttons.draw -text Draw \
    -relief raised \
    -command "" 
    button $w.f1.buttons.aceptar -text Accept \
    -relief raised \
    -command "myAppAcceptLE $w" 
    button $w.f1.buttons.cancelar -text Cancel \
    -relief raised \
    -command "" 
    button $w.f1.buttons.ayuda -text Help \
    -relief raised \
    -command "" 

# Inserta los botones de aceptar/cancelar. 
    pack $w.f1.buttons.draw -side left 
    pack $w.f1.buttons.aceptar -side left 
    pack $w.f1.buttons.cancelar -side left 
    pack $w.f1.buttons.ayuda -side left 

# Crea el marco donde colocar la barra de mensajes inferior. 
    frame $w.f1.barra -relief groove -borderwidth 2 -bg yellow
    pack $w.f1.barra -side bottom -fill x -pady 1m -padx 2m 
    label $w.f1.barra.label -textvar mensaje -relief sunken 
    pack $w.f1.barra.label -side top -expand true -fill x 

# Crea los bind para la barra de mensajes. 
    bind $w.f1.m1.l1 <Motion> {set mensaje "a axis ellipse" } 
    bind $w.f1.m1.e1 <Motion> {set mensaje "a axis ellipse" } 
    bind $w.f1.m2.l1 <Motion> { set mensaje "b axis ellipse" } 
    bind $w.f1.m2.e1 <Motion> { set mensaje "Hora de extraccion de los datos" } 
    bind $w.f1.m3.l1 <Motion> { set mensaje "Intervalo entre datos" } 
    bind $w.f1.m3.e1 <Motion> { set mensaje "Intervalo entre datos" }

    bind $w.f1.buttons.aceptar <Motion> { set mensaje "Acepta los cambios efectuados \
    y cierra la ventana" }
    bind $w.f1.buttons.cancelar <Motion> { set mensaje "Cierra la ventana sin aceptar \
    los cambios efectuados" }
    bind $w.f1.buttons.ayuda <Motion> { set mensaje "Hace aparecer la ventana de \
    ayuda para esta ventana" }

    bind $w.f1.m1.l1 <Leave> { set mensaje "" }
    bind $w.f1.m1.e1 <Leave> { set mensaje "" }
    bind $w.f1.m2.l1 <Leave> { set mensaje "" }
    bind $w.f1.m2.e1 <Leave> { set mensaje "" }
    bind $w.f1.m3.l1 <Leave> { set mensaje "" }
    bind $w.f1.m3.e1 <Leave> { set mensaje "" }

    bind $w.f1.buttons.aceptar <Leave> { set mensaje "" }
    bind $w.f1.buttons.cancelar <Leave> { set mensaje "" }
    bind $w.f1.buttons.ayuda <Leave> { set mensaje "" }

    # Crea los bind del teclado: 
    # Se sale sin salvar los cambios con "Escape" 
    bind $w <Return> "AceptarFechInte $w" 
    bind $w <Escape> "CancelarFechInte $w" 

    # Inicializa las variables. 
    $w.f1.m1.e1 delete 0 end 
    $w.f1.m2.e1 delete 0 end 
    $w.f1.m3.e1 delete 0 end 
    $w.f1.m4.e1 delete 0 end 
    $w.f1.m5.e1 delete 0 end 

    $w.f1.m1.e1 insert 0 $a1_le
    $w.f1.m2.e1 insert 0 $b1_le 
    $w.f1.m3.e1 insert 0 $x1_le
    $w.f1.m4.e1 insert 0 $xm_le 
    $w.f1.m5.e1 insert 0 $c0_le

#----------------------------------------------------------------------

}

#----------------------------------------------------------------------
#   proc myAppAcceptLE
#----------------------------------------------------------------------
proc myAppAcceptLE { v } { 
    global data_le 
    # Capture data
    set data_le(a1) [$v.f1.m1.e1 get] 
    set data_le(b1) [$v.f1.m2.e1 get]  
    set data_le(x1) [$v.f1.m3.e1 get] 
    set data_le(xm) [$v.f1.m4.e1 get]  
    set data_le(c0) [$v.f1.m5.e1 get] 
    # Destruye la toplevel
    destroy $v 

#   Opcio colocar independent:

#   Call update all variables
#   Call write new leparagiding.txt

    # Destroy frames in main before new call
    destroy .uno
    destroy .dos
    destroy .tres
    # Call main window
    myAppWriteMain

    } 


