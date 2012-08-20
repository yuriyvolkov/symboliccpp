#!/usr/bin/awk -f

BEGIN					{ doprint=1 }

/^#if.*/				{ if(def == "") def=$2 }

/^#undef *SYMBOLIC_DEFINE$/		{ $0="" }

/^#define *LIBSYMBOLICCPLUSPLUS$/	{ doprint=0 }
					{ if(doprint == 1) print }
/^#undef *LIBSYMBOLICCPLUSPLUS$/	{ doprint=1 }

/^#ifdef *SYMBOLIC_DECLARE$/		{ print "#define " def }
