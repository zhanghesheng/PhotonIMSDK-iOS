#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MDAppBus.h"
#import "MDLoggerService.h"
#import "MMLiveService.h"
#import "MMProxyService.h"

FOUNDATION_EXPORT double MMAppBusVersionNumber;
FOUNDATION_EXPORT const unsigned char MMAppBusVersionString[];

