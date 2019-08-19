//
//  MDLoggerService.h
//  MDLog
//
//  Created by Dai Dongpeng on 2017/5/19.
//  Copyright © 2017年 wemomo. All rights reserved.
//

#ifndef MDLoggerService_h
#define MDLoggerService_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MDLogLevel)
{
    MDLogLevelALL,
    MDLogLevelDebug,
    
    MDLogLevelInformation,
    MDLogLevelWarning,
    MDLogLevelError,
    MDLogLevelEvent,
    MDLogLevelEA,
    MDLogLevelNone
};

@protocol MDLoggerService <NSObject>

//@required
//- (BOOL)canLogWithLevel:(MDLogLevel)level tag:(nullable NSString *)tag;

- (void)loggerWithLevel:(MDLogLevel)level
                    tag:(nonnull NSString *)tag
                   file:(nonnull NSString *)file
               function:(nonnull NSString *)function
                   line:(int)line
                message:(nonnull NSString *)message;

//@optional
//- (void)registerWhiteList:(nullable NSArray <NSString *> *)list;

@end

#endif /* MDLoggerService_h */
