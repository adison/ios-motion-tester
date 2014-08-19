//  固定用的一些 macro 方法，不牵涉 app 变数定义

// 取角度, convert radius to angle
#define degreesToRadian(x) (M_PI * (x) / 180.0)

//取螢幕尺寸, screen resolution
#define kScreenWidth      [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight     [[UIScreen mainScreen] bounds].size.height

//判斷是否 iPhone 5, this may need change after iphone6..
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// 設定顏色, easy color set
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)(rgbValue & 0xFF00 >> 8))/255.0 alpha:((float)(rgbValue & 0xFF >> 8))/255.0]

// 背景執行, background queue
#define BgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#pragma mark - for NSLogger
// NSLogger 定义
//#import <NSLogger/LoggerClient.h>
////#ifdef DEBUG
//#define LOG_NETWORK(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"network",level,__VA_ARGS__)
////#define LOG_NETWORK(level, ...)    NSLog(__VA_ARGS__)
//#define LOG_GENERAL(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"general",level,__VA_ARGS__)
////#define LOG_GENERAL(level, ...)    NSLog(__VA_ARGS__)
//#define LOG_GRAPHICS(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"graphics",level,__VA_ARGS__)
////#define LOG_GRAPHICS(level, ...)    NSLog(__VA_ARGS__)
//#define NSLog(...) LogMessageF( __FILE__,__LINE__,__FUNCTION__,nil, 5,__VA_ARGS__)
//#define NSLog(...) NSLog(__VA_ARGS__)

//#else
//#define LOG_NETWORK(...)    do{}while(0)
//#define LOG_GENERAL(...)    do{}while(0)
//#define LOG_GRAPHICS(...)   do{}while(0)
//#endif

// crash 时输出资料
#if defined(DEBUG) && !defined(NDEBUG)
#undef assert
#if __DARWIN_UNIX03
#define assert(e) \
(__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert_rtn(__func__, __FILE__, __LINE__, #e)) : (void)0)
#else
#define assert(e)  \
(__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert(#e, __FILE__, __LINE__)) : (void)0)
#endif
#endif


#pragma mark - version comparation
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// some universal
#ifdef __IPHONE_6_0
#define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
#define LINE_ALIGNMENT_LEFT NSTextAlignmentLeft
#define LINE_ALIGNMENT_CENTER NSTextAlignmentCenter
#define LINE_ALIGNMENT_RIGHT NSTextAlignmentRight
// something might be added later
//  NSLineBreakByWordWrapping
//  NSLineBreakByTruncatingTail
//  NSLineBreakByWordWrapping
#else
#define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
#define LINE_ALIGNMENT_LEFT UITextAlignmentLeft
#define LINE_ALIGNMENT_CENTER UITextAlignmentCenter
#define LINE_ALIGNMENT_RIGHT UITextAlignmentRight
#endif

#pragma mark - lazy methos..
#define NSPRINTF(f, ...) [NSString stringWithFormat:f, __VA_ARGS__]
