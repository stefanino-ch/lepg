#---------------------------------------------------------------------
#
#  Global Wing variables used across lep and lepg including explanations
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

proc invokeBrowser { url } {
  # open is the OS X equivalent to xdg-open on Linux, start is used on Windows
  set commands {xdg-open open start}
  foreach browser $commands {
    if {$browser eq "start"} {
      set command [list {*}[auto_execok start] {}]
    } else {
      set command [auto_execok $browser]
    }
    if {[string length $command]} {
      break
    }
  }

  if {[string length $command] == 0} {
    return -code error "couldn't find browser"
  }
  if {[catch {exec {*}$command $url &} error]} {
    return -code error "couldn't execute '$command': $error"
  }
}

proc displayHelpfile { Filename } {
    global ::GlobalConfig

    set Myself [file normalize [info script]]
    set MyLocation [file dirname $Myself]

    set Lang [dict get $::GlobalConfig Language]
    # Check for available languages
    switch $Lang {
        de {}
        default {set Lang en}
    }

    if {$Filename == "index" } {
        set Argument "$MyLocation/doc/$Filename"
    } else {
        set Argument "$MyLocation/doc/$Lang/$Filename"
    }

    append Argument .html

    invokeBrowser $Argument
}
