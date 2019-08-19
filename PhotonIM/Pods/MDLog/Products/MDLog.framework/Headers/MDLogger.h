//
//  MDLogger.h
//  MDLog
//
//  Created by Dai Dongpeng on 2017/5/19.
//  Copyright © 2017年 wemomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMAppBus/MDLoggerService.h>
#import "xlogger.h"

TLogLevel TLogLevelFrom(MDLogLevel level);

//typedef void(^MDLoggerBlock) ((MDLogLevel)level (NSString *)tag (NSString *)file (NSString *)function line:(int)line message:(NSString *)message);
typedef void (^MDLoggerBlock) (MDLogLevel level, NSString * _Nonnull tag, NSString * _Nonnull file, NSString * _Nonnull func, int line, NSString * _Nonnull message);

@interface MDLogger : NSObject <MDLoggerService>

@property (nonatomic, copy) MDLoggerBlock _Nullable eaBlock;
/*
 指定初始化方法

 @param path log 所在的目录
 @return logger
 */
- (nullable instancetype)initWithFilePath:(nonnull NSString *)path;
- (void)setLogLevel:(MDLogLevel)logLevel;
- (void)setConsoleEnable:(BOOL)en;
- (void)setMaxBytesFileSize:(UInt64)max;
// 控制台输出用
- (void)setEnableFewerConsoleOutput:(BOOL)en;
/**
 //配置完之后要调用
 */
- (void)start;
- (void)flushSync:(BOOL)sync;
- (void)stop;
- (nullable NSString *)currentLogPath;
- (nullable NSString *)currentLogCachePath;

- (void)registerWhiteList:(nullable NSArray <NSString *> *)list;

/**
  debug 模式下决定是否在控制台输出Log
 
 @param tags 需要在控制台输出log的tags白名单，如果不设置，默认全部输出
 @param level tags对应的level，只能设置为    MDLogLevelDebug, MDLogLevelInformation, MDLogLevelEvent, 三者中的一个，设置其他无效。为了便于发现其他问题， warniing 和 error 级别的Log不能关闭。
 */
- (void)setShouldConsoleTags:(NSArray <NSString *> *_Nullable)tags forLevel:(MDLogLevel)level;

@end


FOUNDATION_EXTERN id<MDLoggerService> __nullable __gMDLogger;

//#ifdef __gMDMMTag
//#undef __gMDMMTag
//#endif
//#define __gMDMMTag @"M"
extern NSString * _Nullable __gMDMMTag;

#define __MDLOG(level, tagStr, fmt, ...) \
do { \
id<MDLoggerService> const __logger = __gMDLogger; \
MDLogLevel const __level = (level); \
 [__logger loggerWithLevel:__level tag:(tagStr) file:@(__FILE__) function:@(__FUNCTION__) line:__LINE__ message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];\
} while (0)

#define __MDLogDebugTag(tag, fmt, ...)        __MDLOG(MDLogLevelDebug, tag, fmt, ##__VA_ARGS__)
#define __MDLogTraceTag(tag)                  __MDLOG(MDLogLevelDebug, tag, @"%@", @"TRACE")
#define __MDLogInformationTag(tag, fmt, ...)  __MDLOG(MDLogLevelInformation, tag, fmt, ##__VA_ARGS__)
#define __MDLogWarningTag(tag, fmt, ...)      __MDLOG(MDLogLevelWarning, tag, fmt, ##__VA_ARGS__)
#define __MDLogErrorTag(tag, fmt, ...)        __MDLOG(MDLogLevelError, tag, fmt, ##__VA_ARGS__)
#define __MDLogEventTag(tag, value)           __MDLOG(MDLogLevelEvent, tag, @"%@", value)
#define __MDLogEATag(tag, value)              __MDLOG(MDLogLevelEA, tag, @"%@", value)
// 使用的时候分别在debug和release下重新定义
/*
 #if defined(DEBUG)
 #define MDLogDebug(fmt, ...) __MDLogDebug__(fmt, ##__VA_ARGS__)
 #else
 #define MDLogDebug(fmt, ...)
 #endif
 */
#define __MDLogDebug__(fmt, ...)        __MDLogDebugTag(__gMDMMTag, fmt, ##__VA_ARGS__)
#define __MDLogTrace__()                __MDLogTraceTag(__gMDMMTag)

#define MDLogInformation(fmt, ...)  __MDLogInformationTag(__gMDMMTag, fmt, ##__VA_ARGS__)
#define MDLogWarning(fmt, ...)      __MDLogWarningTag(__gMDMMTag, fmt, ##__VA_ARGS__)
#define MDLogError(fmt, ...)        __MDLogErrorTag(__gMDMMTag, fmt, ##__VA_ARGS__)
#define MDLogEvent(value)           __MDLogEventTag(__gMDMMTag, value)
#define MDLogEA(value)              __MDLogEATag(__gMDMMTag, value)

