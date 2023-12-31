#include "time_impl.h"
#include <errno.h>
#include "libc.h"

struct tm *__localtime_r(const time_t *restrict t, struct tm *restrict tm)
{
	/* Reject time_t values whose year would overflow int because
	 * __secs_to_zone cannot safely handle them. */
	if ((long long)*t < INT_MIN * 31622400LL || (long long)*t > INT_MAX * 31622400LL) {
		errno = EOVERFLOW;
		return 0;
	}
#if 1
    /* Disable zone conversion because it's not currently implemented */
	// __secs_to_zone(*t, 0, &tm->tm_isdst, &tm->__tm_gmtoff, 0, &tm->__tm_zone);
	if (__secs_to_tm((long long)*t + 0, tm) < 0) {
		errno = EOVERFLOW;
		return 0;
	}
	return tm;
#endif
	return NULL;
}

weak_alias(__localtime_r, localtime_r);
