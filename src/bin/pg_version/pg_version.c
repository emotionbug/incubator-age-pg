/*-------------------------------------------------------------------------
 *
 * pg_version.c--
 *    
 *
 * Copyright (c) 1994, Regents of the University of California
 *
 *
 * IDENTIFICATION
 *    $Header: /cvsroot/pgsql/src/bin/pg_version/Attic/pg_version.c,v 1.6 1996/11/12 06:47:00 bryanh Exp $
 *
 *-------------------------------------------------------------------------
 */
#include <stdlib.h>
#include <stdio.h>

#include <version.h>    /* interface to SetPgVersion */



int
main(int argc, char **argv)
{
    int retcode;    /* our eventual return code */
    char *reason;   /* Reason that SetPgVersion failed, NULL if it didn't. */

    if (argc < 2) {
	fprintf(stderr, "pg_version: missing argument\n");
	exit(1);
    }
    SetPgVersion(argv[1], &reason);
    if (reason) {
        fprintf(stderr, 
                "pg_version is unable to create the PG_VERSION file. "
                "SetPgVersion gave this reason: %s\n",
                reason);
        retcode = 10;
    } else retcode = 0;
    return(retcode);
}
