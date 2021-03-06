/*-------------------------------------------------------------------------
 *
 * dynloader.c--
 *    This dynamic loader uses Andrew Yu's libdl-1.0 package for Ultrix 4.x.
 *    (Note that pg_dlsym and pg_dlclose are actually macros defined in
 *    "port-protos.h".)
 *    
 * Copyright (c) 1994, Regents of the University of California
 *
 *
 * IDENTIFICATION
 *    $Header: /cvsroot/pgsql/src/backend/port/ultrix4/Attic/dynloader.c,v 1.3 1996/11/26 03:18:50 bryanh Exp $
 *
 *-------------------------------------------------------------------------
 */
#include <stdio.h>
#include <postgres.h>
#include "dl.h"
#include <utils/dynamic_loader.h>
#include "c.h"
#include "fmgr.h"
#include "port-protos.h"
#include "utils/elog.h"

extern char pg_pathname[];

void *
pg_dlopen(char *filename)
{
    static int dl_initialized= 0;
    void *handle;

    /*
     * initializes the dynamic loader with the executable's pathname.
     * (only needs to do this the first time pg_dlopen is called.)
     */
    if (!dl_initialized) {
        if (!dl_init(pg_pathname)) {
	    return NULL;
	}
	/*
	 * if there are undefined symbols, we want dl to search from the
	 * following libraries also.
	 */
	dl_setLibraries("/usr/lib/libm_G0.a:/usr/lib/libc_G0.a");
	dl_initialized= 1;
    }

    /*
     * open the file. We do the symbol resolution right away so that we
     * will know if there are undefined symbols. (This is in fact the
     * same semantics as "ld -A". ie. you cannot have undefined symbols.
     */
    if ((handle=dl_open(filename, DL_NOW))==NULL) {
	int count;
	char **list= dl_undefinedSymbols(&count);

	/* list the undefined symbols, if any */
	if(count) {
	    elog(NOTICE, "dl: Undefined:");
	    while(*list) {
		elog(NOTICE, "  %s", *list);
		list++;
	    }
	}
    }

    return (void *)handle;
}

