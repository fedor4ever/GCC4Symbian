/* generated for  xgcc.exe (GCC) 11.2.0 */

#ifndef GCC_GENERATED_STDINT_H
#define GCC_GENERATED_STDINT_H 1

// #include <sys/types.h>
// #include <stddef.h>
/* glibc uses these symbols as guards to prevent redefinitions.  */
#ifdef __int8_t_defined
#define _INT8_T
#define _INT16_T
#define _INT32_T
#endif
#ifdef __uint32_t_defined
#define _UINT32_T
#endif


#ifndef _UINT8_T
#define _UINT8_T
#ifndef __uint8_t_defined
#define __uint8_t_defined
#ifndef uint8_t
typedef unsigned char uint8_t;
#endif
#endif
#endif

#ifndef _UINT16_T
#define _UINT16_T
#ifndef __uint16_t_defined
#define __uint16_t_defined
#ifndef uint16_t
typedef unsigned short uint16_t;
#endif
#endif
#endif

#ifndef _UINT32_T
#define _UINT32_T
#ifndef __uint32_t_defined
#define __uint32_t_defined
#ifndef uint32_t
typedef unsigned int uint32_t;
#endif
#endif
#endif

#ifndef _INT8_T
#define _INT8_T
#ifndef __int8_t_defined
#define __int8_t_defined
#ifndef int8_t
typedef char int8_t;
#endif
#endif
#endif

#ifndef _INT16_T
#define _INT16_T
#ifndef __int16_t_defined
#define __int16_t_defined
#ifndef int16_t
typedef short int16_t;
#endif
#endif
#endif

#ifndef _INT32_T
#define _INT32_T
#ifndef __int32_t_defined
#define __int32_t_defined
#ifndef int32_t
typedef int int32_t;
#endif
#endif
#endif

/* some common heuristics for int64_t, using compiler-specific tests */
#if defined __STDC_VERSION__ && (__STDC_VERSION__-0) >= 199901L
#ifndef _INT64_T
#define _INT64_T
#ifndef __int64_t_defined
#ifndef int64_t
typedef long long int64_t;
#endif
#endif
#endif
#ifndef _UINT64_T
#define _UINT64_T
#ifndef uint64_t
typedef unsigned long long uint64_t;
#endif
#endif

#elif defined __GNUC__ && defined (__STDC__) && __STDC__-0
/* NextStep 2.0 cc is really gcc 1.93 but it defines __GNUC__ = 2 and
does not implement __extension__.  But that compiler doesn't define
__GNUC_MINOR__.  */
# if __GNUC__ < 2 || (__NeXT__ && !__GNUC_MINOR__)
# define __extension__
# endif

# ifndef _INT64_T
# define _INT64_T
# ifndef int64_t
__extension__ typedef long long int64_t;
# endif
# endif
# ifndef _UINT64_T
# define _UINT64_T
# ifndef uint64_t
__extension__ typedef unsigned long long uint64_t;
# endif
# endif

#elif !defined __STRICT_ANSI__
# if defined _MSC_VER || defined __WATCOMC__ || defined __BORLANDC__

#  ifndef _INT64_T
#  define _INT64_T
#  ifndef int64_t
typedef __int64 int64_t;
#  endif
#  endif
#  ifndef _UINT64_T
#  define _UINT64_T
#  ifndef uint64_t
typedef unsigned __int64 uint64_t;
#  endif
#  endif
# endif /* compiler */

#endif /* ANSI version */

/* Define intptr_t based on sizeof(void*) = 4 */
#ifndef __uintptr_t_defined
#ifndef uintptr_t
typedef uint32_t uintptr_t;
#endif
#endif
#ifndef __intptr_t_defined
#ifndef intptr_t
typedef int32_t  intptr_t;
#endif
#endif

/* Define int_least types */
typedef int8_t     int_least8_t;
typedef int16_t    int_least16_t;
typedef int32_t    int_least32_t;
#ifdef _INT64_T
typedef int64_t    int_least64_t;
#endif

typedef uint8_t    uint_least8_t;
typedef uint16_t   uint_least16_t;
typedef uint32_t   uint_least32_t;
#ifdef _UINT64_T
typedef uint64_t   uint_least64_t;
#endif

/* Define int_fast types.  short is often slow */
typedef int8_t       int_fast8_t;
typedef int          int_fast16_t;
typedef int32_t      int_fast32_t;
#ifdef _INT64_T
typedef int64_t      int_fast64_t;
#endif

typedef uint8_t      uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef uint32_t     uint_fast32_t;
#ifdef _UINT64_T
typedef uint64_t     uint_fast64_t;
#endif

/* Define intmax based on what we found */
#ifndef intmax_t
#ifdef _INT64_T
typedef int64_t       intmax_t;
#else
typedef long          intmax_t;
#endif
#endif
#ifndef uintmax_t
#ifdef _UINT64_T
typedef uint64_t      uintmax_t;
#else
typedef unsigned long uintmax_t;
#endif
#endif

#endif /* GCC_GENERATED_STDINT_H */
