#ifndef _DEBUG_STDIO_
#define _DEBUG_STDIO_

void debug_putc(char c);
void debug_puts(const char* s);

[[gnu::format(printf, 1, 2)]]
void debug_printf(const char* fmt, ...);

#ifdef __DEBUG__

	#define DEBUG_PUTC(c)		   debug_putc(c)
	#define DEBUG_PUTS(s)		   debug_puts(s)
	#define DEBUG_PRINTF(fmt, ...) debug_printf(fmt __VA_OPT__(, ) __VA_ARGS__)

#else

// for argument checking
[[gnu::format(printf, 1, 2)]] static inline void noop_printf(const char*, ...) {}

	#define DEBUG_PUTC(c)
	#define DEBUG_PUTS(s)
	#define DEBUG_PRINTF(fmt, ...) noop_printf(fmt __VA_OPT(, ) __VA_ARGS__)

#endif // !__DEBUG__

#endif // !_DEBUG_STDIO_
