#author mask.yang
#version 2.0
{
	if ( match($0,/denied/) > 0) {
		if ( match($0,/scontext/) > 0 ) {
			start = match($0,/{/)
			end = match($0,/}/)
			permissive = substr($0,start,end - start + 1)
			for (i = 1 ;i < NF ; i++ ){
				if ( match($i,/^scontext*/) > 0 ) {
					split($i,sc,":")
				}
				if ( match($i,/^tcontext*/) > 0 ) {
					split($i,tc,":")
				}
				if ( match($i,/^tclass*/) > 0 ) {
					split($i,tcl,"=")
				}
			}
			print "allow "sc[3]" "tc[3]":"tcl[2]" "permissive ";"
		}
	}
}
