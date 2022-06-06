#ifndef FAKE_SYMBIAN_STDIO_H
#define FAKE_SYMBIAN_STDIO_H

#    define     EOF             (-1)
#    define     SEEK_SET        0       /* set file offset to offset */
#    define     SEEK_CUR        1       /* set file offset to current plus offset */
#    define     SEEK_END        2       /* set file offset to EOF plus offset */

/*
#if defined __has_include
#  if __has_include (<stdio.h>)
#warning "__has_include (<stdio.h>)"
#    include <stdio.h>
#  else
#    define     EOF             (-1)
#    define     SEEK_SET        0       /* set file offset to offset */
/*#    define     SEEK_CUR        1       /* set file offset to current plus offset */
/*#    define     SEEK_END        2       /* set file offset to EOF plus offset */
/*#  endif
#endif
*/

#endif FAKE_SYMBIAN_STDIO_H