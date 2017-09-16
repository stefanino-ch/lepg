# lepConfigFile.tcl --
#
# This file implements the Tcl code for the management of the lep-gui
# config file.
#
# Stefan Feuz
#
# General Public License GNU GPL 3.0
#

package provide lepConfigFile 	1.0
package require Tcl 			8.6

namespace eval lepConfigFile {
    namespace export loadFile {ConfigData}
    namespace export saveFile {ConfigData}
}

proc lepConfigFile::loadFile {ConfigData} {
	set ConfigFile [open lep-gui-conf.txt r]
    while {[gets $ConfigFile ConfigLine] >= 0} {
        set Tmp [string first ":" $ConfigLine]
        set Key [string range $ConfigLine 0 [expr $Tmp - 1]]
        set Value [string range $ConfigLine [expr $Tmp + 1] end]
        puts $Key
        puts $Value
        
        dict set ConfigData $Key $Value
    }
    close $ConfigFile
    return $ConfigData
}

proc lepConfigFile::saveFile {ConfigData} {
    set ConfigFile [open lep-gui-conf.txt w]
    dict for {Key Value} $ConfigData {puts $ConfigFile "$Key:$Value"}
    close $ConfigFile
    return
}
