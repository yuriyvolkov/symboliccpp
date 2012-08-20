#!/usr/bin/awk -f

BEGIN					{ doprint=0 }

/^#undef *LIBSYMBOLICCPLUSPLUS$/	{ doprint=0 }
					{ if(doprint == 1) print }
/^#define *LIBSYMBOLICCPLUSPLUS$/	{ doprint=1 }
