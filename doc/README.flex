From: ernst.molitor@uni-bonn.de

Hi,

thank you for the latest Postgres95 distribution! 

>does the createuser bug still persist, or have
>we finally worked that one out?

As has been indication by Bruce Momjian, the createuser problem was
caused by a bug in flex 2.5.3 (which has been confirmed by Vern
Paxson, the flex maintainer - many thanks to them); the bug will be
fixed in flex 2.5.4. Vern Paxson has been so kind as to supply me with
a patch that will be part of the 2.5.4 release; I'm including it below
in case someone has installed flex 2.5.3 and doesn't want to go
back to 2.5.2...

Regards,

Ernst
---
*** flex-2.5.3/flex.skl	Sat May 25 21:02:33 1996
--- flex.skl	Tue Jul  2 16:35:49 1996
***************
*** 1,7 ****
  /* A lexical scanner generated by flex */

  /* Scanner skeleton version:
!  * $Header: /cvsroot/pgsql/doc/Attic/README.flex,v 1.1.1.1 1996/08/18 22:14:17 scrappy Exp $
   */

  #define FLEX_SCANNER
--- 1,7 ----
  /* A lexical scanner generated by flex */

  /* Scanner skeleton version:
!  * $Header: /cvsroot/pgsql/doc/Attic/README.flex,v 1.1.1.1 1996/08/18 22:14:17 scrappy Exp $
   */

  #define FLEX_SCANNER
***************
*** 783,789 ****
  		/* don't do the read, it's not guaranteed to return an EOF,
  		 * just force an EOF
  		 */
! 		yy_n_chars = 0;

  	else
  		{
--- 783,789 ----
  		/* don't do the read, it's not guaranteed to return an EOF,
  		 * just force an EOF
  		 */
! 		yy_current_buffer->yy_n_chars = yy_n_chars = 0;

  	else
  		{
***************
*** 838,843 ****
--- 838,845 ----
  		/* Read in more data. */
  		YY_INPUT( (&yy_current_buffer->yy_ch_buf[number_to_move]),
  			yy_n_chars, num_to_read );
+
+ 		yy_current_buffer->yy_n_chars = yy_n_chars;
  		}

  	if ( yy_n_chars == 0 )
***************
*** 947,953 ****

  		yy_cp += (int) (dest - source);
  		yy_bp += (int) (dest - source);
! 		yy_n_chars = yy_current_buffer->yy_buf_size;

  		if ( yy_cp < yy_current_buffer->yy_ch_buf + 2 )
  			YY_FATAL_ERROR( "flex scanner push-back overflow" );
--- 949,956 ----

  		yy_cp += (int) (dest - source);
  		yy_bp += (int) (dest - source);
! 		yy_current_buffer->yy_n_chars =
! 			yy_n_chars = yy_current_buffer->yy_buf_size;

  		if ( yy_cp < yy_current_buffer->yy_ch_buf + 2 )
  			YY_FATAL_ERROR( "flex scanner push-back overflow" );
***************
*** 997,1009 ****

  			switch ( yy_get_next_buffer() )
  				{
  				case EOB_ACT_END_OF_FILE:
  					{
  					if ( yywrap() )
- 						{
- 						yy_c_buf_p = yytext_ptr + offset;
  						return EOF;
- 						}

  					if ( ! yy_did_buffer_switch_on_eof )
  						YY_NEW_FILE;
--- 1000,1025 ----

  			switch ( yy_get_next_buffer() )
  				{
+ 				case EOB_ACT_LAST_MATCH:
+ 					/* This happens because yy_g_n_b()
+ 					 * sees that we've accumulated a
+ 					 * token and flags that we need to
+ 					 * try matching the token before
+ 					 * proceeding.  But for input(),
+ 					 * there's no matching to consider.
+ 					 * So convert the EOB_ACT_LAST_MATCH
+ 					 * to EOB_ACT_END_OF_FILE.
+ 					 */
+
+ 					/* Reset buffer status. */
+ 					yyrestart( yyin );
+
+ 					/* fall through */
+
  				case EOB_ACT_END_OF_FILE:
  					{
  					if ( yywrap() )
  						return EOF;

  					if ( ! yy_did_buffer_switch_on_eof )
  						YY_NEW_FILE;
***************
*** 1017,1031 ****
  				case EOB_ACT_CONTINUE_SCAN:
  					yy_c_buf_p = yytext_ptr + offset;
  					break;
-
- 				case EOB_ACT_LAST_MATCH:
- #ifdef __cplusplus
- 					YY_FATAL_ERROR(
- 					"unexpected last match in yyinput()" );
- #else
- 					YY_FATAL_ERROR(
- 					"unexpected last match in input()" );
- #endif
  				}
  			}
  		}
--- 1033,1038 ----

